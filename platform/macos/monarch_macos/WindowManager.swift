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
    var isFlutterWindowReady: Bool = false
    
    let logger: Logger = Logger("WindowManager")
    
    func launchWindows() {
        // self.checkCommandLineArguments()
        let controller = _initFlutterViewController("/Users/fertrig/development/monarch_product/monarch_shift/out/monarch/bin/cache/monarch_ui/flutter_macos_2.10.3-stable/controller")
        let preview = _initFlutterViewController("/Users/fertrig/development/scratch/multi/multi_preview/.mariposa")
        
        
//        let controller = _initFlutterViewController("/Users/fertrig/development/scratch/multi/multi_controller")
//        let preview = _initFlutterViewController("/Users/fertrig/development/scratch/multi/multi_preview")
        
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
        
        //        RegisterGeneratedPlugins(registry: flutterViewController)
        
        if let previewWindow = previewWindow, let controllerWindow = controllerWindow {
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
                        self._getPreviewWindowTopLeft(DockSide.right))
                })
            
            NotificationCenter.default.addObserver(
                forName: NSWindow.didResizeNotification,
                object: controllerWindow,
                queue: OperationQueue.main,
                using: { (n: Notification) in
                    previewWindow.setFrameTopLeftPoint(
                        self._getPreviewWindowTopLeft(DockSide.right))
                })
            
            NotificationCenter.default.addObserver(
                forName: NSWindow.didMoveNotification,
                object: previewWindow,
                queue: OperationQueue.main,
                using: { (n: Notification) in
                    controllerWindow.setFrameTopLeftPoint(
                        self._getControllerWindowTopLeft(DockSide.right))
                })
            
//            NotificationCenter.default.addObserver(
//                forName: NSWindow.didChangeScreenNotification,
//                object: flutterWindow,
//                queue: OperationQueue.main,
//                using: { (n: Notification) in
//                    ChannelMethodsSender.setActiveDevice(
//                        deviceId: verticalViewController.selectedDeviceId)
//                })
        }
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
    
    func changeFlutterWindowDockSide(_ side: DockSide) {
        previewWindow!.setFrameTopLeftPoint(_getPreviewWindowTopLeft(side))
    }
    
    func undockFlutterWindow() {
        let offset: CGFloat = 24
        let pos = _getTopLeftPoint(previewWindow!)
        previewWindow!.setFrameTopLeftPoint(NSPoint(x: pos.x + offset, y: pos.y - offset))
    }
    
    func resizeFlutterWindow(size: NSSize, title: String, side: DockSide) {
        if let flutterWindow = previewWindow {
            //let lastTopLeft = _getTopLeftPoint(flutterWindow)
            flutterWindow.setContentSize(size)
            flutterWindow.setFrameTopLeftPoint(_getPreviewWindowTopLeft(side))
            flutterWindow.title = title
        }
    }
    
}

let distanceBetweenWindows: CGFloat = 1.0
