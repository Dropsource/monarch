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
    
    var previewWindow: NSWindow?
    var controllerWindow: NSWindow?
    var channels: Channels?
    
    var selectedDockSide: DockSide = defaultDockSide
    
    let logger: Logger = Logger("WindowManager")
    
    func launchWindows() {
         self.checkCommandLineArguments()
    }
    
    func checkCommandLineArguments() {
        let arguments = CommandLine.arguments
        
        logger.fine("arguments \(arguments)");
        
        var controllerBundlePath: String?
        var projectBundlePath: String?
        
        
        if (arguments.count > 2 && arguments[1] == "--controller-bundle") {
            controllerBundlePath = arguments[2]
        }
        if (arguments.count > 4 && arguments[3] == "--project-bundle") {
            projectBundlePath = arguments[4]
        }
        if (arguments.count > 6 && arguments[5] == "--log-level") {
            defaultLogLevel = logLevelFromString(levelString: arguments[6])
        }
        
        if let controllerBundlePath = controllerBundlePath,
           let projectBundlePath = projectBundlePath {
            self._loadWindows(
                controllerBundlePath: controllerBundlePath,
                previewBundlePath: projectBundlePath)
        }
    }
    
    func _loadWindows(controllerBundlePath: String, previewBundlePath: String) {
        let controller = _initFlutterViewController(controllerBundlePath)
        let preview = _initFlutterViewController(previewBundlePath)
        
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
        
        guard let controllerWindow = controllerWindow,
              let previewWindow = previewWindow else { return }
        
        controllerWindow.contentViewController = controllerFVC
        previewWindow.contentViewController = previewFVC
                
        let controllerWindowController = NSWindowController()
        let previewWindowController = NSWindowController()
        
        controllerWindowController.contentViewController = controllerWindow.contentViewController
        previewWindowController.contentViewController = previewWindow.contentViewController
        
        controllerWindow.setContentSize(NSSize(width: 700, height: 830))
        controllerWindow.title = "Monarch"
        controllerWindowController.window = controllerWindow
        controllerWindowController.showWindow(self)
        
        previewWindow.setContentSize(defaultDeviceDefinition.logicalResolution.size)
        previewWindow.setFrameTopLeftPoint(_getPreviewWindowTopLeft(defaultDockSide))
        previewWindow.title = defaultDeviceDefinition.title
        
        previewWindow.styleMask.insert(.closable)
        previewWindow.styleMask.insert(.miniaturizable)
        
        previewWindowController.window = previewWindow
        previewWindowController.showWindow(self)
        
        // bring windows to front
        NSApp.activate(ignoringOtherApps: true)
        
        NotificationCenter.default.addObserver(
            forName: NSWindow.didMoveNotification,
            object: controllerWindow,
            queue: OperationQueue.main,
            using: { (n: Notification) in
                previewWindow.setFrameTopLeftPoint(
                    self._getPreviewWindowTopLeft(self.selectedDockSide))
            })
        
        NotificationCenter.default.addObserver(
            forName: NSWindow.didResizeNotification,
            object: controllerWindow,
            queue: OperationQueue.main,
            using: { (n: Notification) in
                previewWindow.setFrameTopLeftPoint(
                    self._getPreviewWindowTopLeft(self.selectedDockSide))
            })
        
        NotificationCenter.default.addObserver(
            forName: NSWindow.didMoveNotification,
            object: previewWindow,
            queue: OperationQueue.main,
            using: { (n: Notification) in
                controllerWindow.setFrameTopLeftPoint(
                    self._getControllerWindowTopLeft(self.selectedDockSide))
            })
        
        NotificationCenter.default.addObserver(
            forName: NSWindow.didChangeScreenNotification,
            object: previewWindow,
            queue: OperationQueue.main,
            using: { (n: Notification) in
                self.channels!.sendPreviewScreenChanged()
            })
        
        NotificationCenter.default.addObserver(
            forName: NSWindow.didChangeScreenNotification,
            object: controllerWindow,
            queue: OperationQueue.main,
            using: { (n: Notification) in
                self.channels!.sendControllerScreenChanged()
            })
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
        channels!.getMonarchState() { (state) -> () in
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
        channels!.getMonarchState() { (state) -> () in
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
