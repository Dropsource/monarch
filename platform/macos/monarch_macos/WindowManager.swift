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
#if USE_FLUTTER_APP_DELEGATE
    let flutterAppDelegate: FlutterAppDelegate
#endif
    
    var previewApiBundlePath: String?
    var previewWindowBundlePath: String?
    var controllerBundlePath: String?
    var cliGrpcServerPort: String?
    var projectName: String?
    
    var previewApi: FlutterEngine?
    var controllerWindow: NSWindow?
    var previewWindow: NSWindow?
    var channels: Channels?
    
    var previewViewController: FlutterViewController?
    
    var observers: [NSObjectProtocol] = []
    
    var selectedDockSide: DockSide = defaultDockSide
    
    let logger: Logger = Logger("WindowManager")
    
#if USE_FLUTTER_APP_DELEGATE
    init(flutterAppDelete: FlutterAppDelegate) {
        self.flutterAppDelegate = flutterAppDelete
    }
#endif
    
    func launchWindows() {
#if USE_FLUTTER_APP_DELEGATE
        logger.info("Using swift compilation condition (i.e. preprocessor directive): USE_FLUTTER_APP_DELEGATE")
#endif
#if USE_APPLICATION_LIFECYCLE_METHODS
        logger.info("Using swift compilation condition (i.e. preprocessor directive): USE_APPLICATION_LIFECYCLE_METHODS")
#endif
         self.checkCommandLineArguments()
    }
    
    func checkCommandLineArguments() {
        let arguments = CommandLine.arguments
        
        logger.fine("arguments \(arguments)");
        
        if (arguments.count < 7) {
            fatalError("Expected 6 arguments in this order: executable-path preview-api-bundle preview-window-bundle controller-bundle log-level cli-grpc-server-port project-name")
        }
        
        previewApiBundlePath = arguments[1]
        previewWindowBundlePath = arguments[2]
        controllerBundlePath = arguments[3]
        defaultLogLevel = logLevelFromString(levelString: arguments[4])
        cliGrpcServerPort = arguments[5]
        projectName = arguments[6]
        
        self._loadWindows()
    }
    
    func _loadWindows() {
        let previewApiProject = _initDartProject(previewApiBundlePath!)
        let previewWindowProject = _initDartProject(previewWindowBundlePath!)
        let controllerProject = _initDartProject(controllerBundlePath!)
        
        previewApiProject.dartEntrypointArguments = [
            logLevelToString(level: defaultLogLevel), cliGrpcServerPort!]
        previewWindowProject.dartEntrypointArguments = [
            logLevelToString(level: defaultLogLevel)]
        controllerProject.dartEntrypointArguments = [
            logLevelToString(level: defaultLogLevel), cliGrpcServerPort!]
        
        previewApi = FlutterEngine.init(
            name: "monarch-preview-api",
            project: previewApiProject,
            allowHeadlessExecution: true)
        previewViewController = FlutterViewController.init(project: previewWindowProject)
        let controllerViewController = FlutterViewController.init(project: controllerProject)
        
        channels = Channels.init(
            previewApiMessenger: previewApi!.binaryMessenger,
            previewWindowMessenger: previewViewController!.engine.binaryMessenger,
            windowManager: self)
        channels!.setUpCallForwarding()
        
        _launchFlutterWindows(previewViewController!, controllerViewController)
        
        /// Run the preview api in its own isolate. Make sure to run it after launching the windows to make sure
        /// devtools inspects the preview widget tree. See [_launchFlutterWindows] below.
        if (!previewApi!.run(withEntrypoint: nil)) {
            fatalError("FlutterEngine.run for preview_api was not successful")
        }
        
        logger.info("monarch-window-manager-ready")
    }
    
    
    func _initDartProject(_ bundlePath: String) -> FlutterDartProject {
        let bundleUrl = URL(fileURLWithPath: bundlePath)
        
        logger.fine("Will use bundle at: \(bundleUrl.path)")
        
        let bundle = Bundle.init(path: bundleUrl.path)
        let project = FlutterDartProject.init(precompiledDartBundle: bundle)
        return project
    }
    
    /**
     * Launches the Monarch Flutter Windows (the preview and the controller windows).
     *
     * @GOTCHA: the preview needs to be launched after the controller to make sure the devtools
     * widget inspector inspects the preview widget tree. This is a workaround until [this issue]
     * (https://github.com/flutter/devtools/issues/4304) is fixed or until the monarch macos code launches
     * the preview and the controller in their own separate applications, similar to how monarch windows
     * does it.
     */
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
#if USE_FLUTTER_APP_DELEGATE
        NSApp.hide(self)
#endif
        
        _tearDownObservers()
        channels!.sendWillClosePreview()
        previewViewController!.engine.shutDownEngine()
#if USE_FLUTTER_APP_DELEGATE && USE_APPLICATION_LIFECYCLE_METHODS
        flutterAppDelegate.removeApplicationLifecycleDelegate(previewViewController!.engine)
#endif
        previewWindow!.close()
        
        let previewWindowProject = _initDartProject(previewWindowBundlePath!)
        previewWindowProject.dartEntrypointArguments = [
            logLevelToString(level: defaultLogLevel)]
        previewViewController = FlutterViewController.init(project: previewWindowProject)
        
        channels!.restartPreviewChannel(
            previewWindowMessenger: previewViewController!.engine.binaryMessenger)
        
        previewWindow = NSWindow()
        _setUpPreviewWindow(previewViewController!, previewWindow!)
        _setUpObservers(controllerWindow!, previewWindow!)
        resizePreviewWindow()

#if USE_FLUTTER_APP_DELEGATE
        NSApp.activate(ignoringOtherApps: true)
#endif
    }
    
    func terminate() {
        controllerWindow?.close()
        previewViewController?.engine.shutDownEngine()
        previewWindow?.close()
        previewApi?.shutDownEngine()
    }
    
    func _setUpControllerWindow(_ controllerFVC: FlutterViewController, _ controllerWindow: NSWindow) {
        controllerWindow.contentViewController = controllerFVC
        let controllerWindowController = NSWindowController()
        controllerWindowController.contentViewController = controllerWindow.contentViewController
        
        controllerWindow.setContentSize(NSSize(width: 700, height: 830))
        controllerWindow.minSize = NSSize(width: 630, height: 440)
        controllerWindow.title = projectName! + " - Monarch"
        
        controllerWindow.styleMask.insert(.closable)
        controllerWindow.styleMask.insert(.miniaturizable)
        controllerWindow.styleMask.insert(.resizable)
        
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

        let queue = OperationQueue.main
        
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
                }),
            
            NotificationCenter.default.addObserver(
                forName: NSWindow.willCloseNotification,
                object: controllerWindow,
                queue: queue,
                using: { (n: Notification) in
                    previewWindow.close()
                }),
            
            NotificationCenter.default.addObserver(
                forName: NSWindow.willCloseNotification,
                object: previewWindow,
                queue: queue,
                using: { (n: Notification) in
                    controllerWindow.close()
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
