//
//  WindowManager.swift
//  monarch_macos
//
//  Created by Fernando Trigoso on 4/6/22.
//

import Foundation


import Cocoa
import FlutterMacOS
import os.log

class WindowManager {
    
    var controllerBundlePath: String?
    var previewBundlePath: String?
    
    var controllerWindow: NSWindow?
    var previewWindow: NSWindow?
    var channels: Channels?
    
    var observers: [NSObjectProtocol] = []
    
    var selectedDockSide: DockSide = defaultDockSide
    
    let logger: Logger = Logger("WindowManager")
    
    func launchWindows() {
         self.checkCommandLineArguments()
    }
    
    func checkCommandLineArguments() {
        let arguments = CommandLine.arguments
        
        logger.fine("arguments \(arguments)");
        
        if (arguments.count > 2 && arguments[1] == "--controller-bundle") {
            controllerBundlePath = arguments[2]
        } else {
            fatalError("Missing argument --controller-bundle")
        }
        if (arguments.count > 4 && arguments[3] == "--preview-bundle") {
            previewBundlePath = arguments[4]
        } else {
            fatalError("Missing argument --preview-bundle")
        }
        if (arguments.count > 6 && arguments[5] == "--log-level") {
            defaultLogLevel = logLevelFromString(levelString: arguments[6])
        }
        
        self._loadWindows()
    }
    
    func _loadWindows() {
        let controller = _initFlutterViewController(controllerBundlePath!)
        let preview = _initFlutterViewController(previewBundlePath!)
        
        channels = Channels.init(
            controllerMessenger: controller.engine.binaryMessenger,
            previewMessenger: preview.engine.binaryMessenger,
            windowManager: self)
        channels!.setUpCallForwarding()
        
        _launchFlutterWindows(preview, controller)
    }
    
    
    func _initFlutterViewController(_ bundlePath: String) -> FlutterViewController {
        let bundleUrl = URL(fileURLWithPath: bundlePath)
        
        logger.fine("Will use bundle at: \(bundleUrl.path)")
        
        let bundle = Bundle.init(path: bundleUrl.path)
        let project = FlutterDartProject.init(precompiledDartBundle: bundle)
        
        return FlutterViewController.init(project: project)
    }
    
    func _launchFlutterWindows(_ previewFVC: FlutterViewController, _ controllerFVC: FlutterViewController) {
        controllerWindow = NSWindow()
        previewWindow = NSWindow()
        
        _setUpControllerWindow(controllerFVC, controllerWindow!)
        _setUpPreviewWindow(previewFVC, previewWindow!)
        
        // bring windows to front
        NSApp.activate(ignoringOtherApps: true)
        
        _setUpObservers(controllerWindow!, previewWindow!)
    }
    
    func restartPreviewWindow() {
        _tearDownObservers()
        channels!.sendWillClosePreview()
        previewWindow!.close()
        let preview = _initFlutterViewController(previewBundlePath!)
        channels!.restartPreviewChannel(previewMessenger: preview.engine.binaryMessenger)
        previewWindow = NSWindow()
        _setUpPreviewWindow(preview, previewWindow!)
        _setUpObservers(controllerWindow!, previewWindow!)
    }
    
    func _setUpControllerWindow(_ controllerFVC: FlutterViewController, _ controllerWindow: NSWindow) {
        controllerWindow.contentViewController = controllerFVC
        let controllerWindowController = NSWindowController()
        controllerWindowController.contentViewController = controllerWindow.contentViewController
        
        controllerWindow.setContentSize(NSSize(width: 700, height: 830))
        controllerWindow.title = "Monarch"
        controllerWindowController.window = controllerWindow
        controllerWindowController.showWindow(self)
    }
    
    func _setUpPreviewWindow(_ previewFVC: FlutterViewController, _ previewWindow: NSWindow) {
        previewWindow.contentViewController = previewFVC
        let previewWindowController = NSWindowController()
        previewWindowController.contentViewController = previewWindow.contentViewController
                
        previewWindow.setContentSize(defaultDeviceDefinition.logicalResolution.size)
        previewWindow.setFrameTopLeftPoint(_getPreviewWindowTopLeft(selectedDockSide))
        previewWindow.title = defaultDeviceDefinition.title
        
        previewWindow.styleMask.insert(.closable)
        previewWindow.styleMask.insert(.miniaturizable)
        
        previewWindowController.window = previewWindow
        previewWindowController.showWindow(self)
    }
    
    func _setUpObservers(_ controllerWindow: NSWindow, _ previewWindow: NSWindow) {

        let queue = OperationQueue.init()
        
        observers.append(contentsOf: [
            NotificationCenter.default.addObserver(
                forName: NSWindow.didMoveNotification,
                object: controllerWindow,
                queue: queue,
                using: { (n: Notification) in
                    previewWindow.setFrameTopLeftPoint(
                        self._getPreviewWindowTopLeft(self.selectedDockSide))
                }),
            
            NotificationCenter.default.addObserver(
                forName: NSWindow.didResizeNotification,
                object: controllerWindow,
                queue: queue,
                using: { (n: Notification) in
                    previewWindow.setFrameTopLeftPoint(
                        self._getPreviewWindowTopLeft(self.selectedDockSide))
                }),
            
            NotificationCenter.default.addObserver(
                forName: NSWindow.didMoveNotification,
                object: previewWindow,
                queue: queue,
                using: { (n: Notification) in
                    controllerWindow.setFrameTopLeftPoint(
                        self._getControllerWindowTopLeft(self.selectedDockSide))
                }),
            
            NotificationCenter.default.addObserver(
                forName: NSWindow.didChangeScreenNotification,
                object: previewWindow,
                queue: queue,
                using: { (n: Notification) in
                    self.channels!.sendPreviewScreenChanged()
                }),
            
            NotificationCenter.default.addObserver(
                forName: NSWindow.didChangeScreenNotification,
                object: controllerWindow,
                queue: queue,
                using: { (n: Notification) in
                    self.channels!.sendControllerScreenChanged()
                })
        ])
    }
    
    func _tearDownObservers() {
        for observer in observers {
            NotificationCenter.default.removeObserver(observer)
        }
        observers.removeAll()
    }
    
    func _getPreviewWindowTopLeft(_ side: DockSide) -> NSPoint {
        switch side {
            case .right:
                return _getRightWindowTopLeft(leftWindow: controllerWindow!)
                
            case .left:
                return _getLeftWindowTopLeft(leftWindow: previewWindow!, rightWindow: controllerWindow!)
                
            case .undock:
                return _getTopLeftPoint(previewWindow!)
        }
    }
    
    func _getControllerWindowTopLeft(_ side: DockSide) -> NSPoint {
        switch side {
            case .right:
                return _getLeftWindowTopLeft(leftWindow: controllerWindow!, rightWindow: previewWindow!)
                
            case .left:
                return _getRightWindowTopLeft(leftWindow: previewWindow!)
                
            case .undock:
                return _getTopLeftPoint(controllerWindow!)
        }
    }
    
    func _getRightWindowTopLeft(leftWindow: NSWindow) -> NSPoint {
        let windowTopLeft = _getTopLeftPoint(leftWindow)
        
        let rightWindowTopLeft = NSPoint(
            x: windowTopLeft.x + leftWindow.frame.width + distanceBetweenWindows,
            y: windowTopLeft.y)
        
        return rightWindowTopLeft
    }
    
    func _getLeftWindowTopLeft(leftWindow: NSWindow, rightWindow: NSWindow) -> NSPoint {
        let rightWindowTopLeft = _getTopLeftPoint(rightWindow)
        
        let leftWindowTopLeft = NSPoint(
            x: rightWindowTopLeft.x - leftWindow.frame.width - distanceBetweenWindows,
            y: rightWindowTopLeft.y)
        
        return leftWindowTopLeft
    }
    
    func _getTopLeftPoint(_ _window: NSWindow) -> NSPoint {
        return NSPoint(
            x: _window.frame.origin.x,
            y: _window.frame.origin.y + _window.frame.height)
    }
    
    func changePreviewWindowDockSide(_ side: DockSide) {
        previewWindow!.setFrameTopLeftPoint(_getPreviewWindowTopLeft(side))
    }
    
    func undockPreviewWindow() {
        let offset: CGFloat = 24
        let pos = _getTopLeftPoint(previewWindow!)
        previewWindow!.setFrameTopLeftPoint(NSPoint(x: pos.x + offset, y: pos.y - offset))
    }
    
    func setDocking() {
        channels!.getMonarchState() { (state) -> Void in
            switch state.dock {
            case .right:
                self.selectedDockSide = .right
                self.changePreviewWindowDockSide(.right)
                break
            case .left:
                self.selectedDockSide = .left
                self.changePreviewWindowDockSide(.left)
                break
            case .undock:
                self.selectedDockSide = .undock
                self.undockPreviewWindow()
                break
            }
        }
    }
    
    func resizePreviewWindow() {
        channels!.getMonarchState() { (state) -> Void in
            let deviceSize = state.device.logicalResolution.size
            let scaledWidth = Double(deviceSize.width) * state.scale.scale
            let scaledHeight = Double(deviceSize.height) * state.scale.scale
            let scaledSize = NSSize.init(
                width: scaledWidth,
                height: scaledHeight)
            let title = state.scale.scale == defaultScaleDefinition.scale ?
                state.device.title :
                state.device.title + " | " + state.scale.name
            self.resizePreviewWindow(size: scaledSize, title: title, side: state.dock)
        }
    }
    
    func resizePreviewWindow(size: NSSize, title: String, side: DockSide) {
        if let previewWindow = previewWindow {
            //let lastTopLeft = _getTopLeftPoint(flutterWindow)
            previewWindow.setContentSize(size)
            previewWindow.setFrameTopLeftPoint(_getPreviewWindowTopLeft(side))
            previewWindow.title = title
        }
    }
    
}

let distanceBetweenWindows: CGFloat = 1.0
