//
//  Channels.swift
//  monarch_macos
//
//  Created by Fernando Trigoso on 4/19/22.
//

import Foundation
import FlutterMacOS

class Channels {
    let previewApiChannel: FlutterMethodChannel
    var previewWindowChannel: FlutterMethodChannel
    let windowManager: WindowManager
    
    init(previewApiMessenger: FlutterBinaryMessenger,
         previewWindowMessenger: FlutterBinaryMessenger,
         windowManager: WindowManager) {
        self.previewApiChannel = FlutterMethodChannel(
            name: "monarch.previewApi",
            binaryMessenger: previewApiMessenger)
        self.previewWindowChannel = FlutterMethodChannel(
            name: "monarch.previewWindow",
            binaryMessenger: previewWindowMessenger)
        self.windowManager = windowManager
    }
    
    func restartPreviewChannel(previewWindowMessenger: FlutterBinaryMessenger) {
        self.unregisterMethodCallHandlers()
        self.previewWindowChannel = FlutterMethodChannel(
            name: "monarch.previewWindow",
            binaryMessenger: previewWindowMessenger)
        self.setUpCallForwarding()
    }
    
    func setUpCallForwarding() {
        self.previewApiChannel.setMethodCallHandler {
            (call: FlutterMethodCall, callback:@escaping FlutterResult) -> Void in
            self.previewWindowChannel.invokeMethod(call.method, arguments: call.arguments) {
                (result) -> Void in
                callback(result)
            }            
            
            switch (call.method) {
                
            case MonarchMethods.setActiveDevice,
                 MonarchMethods.setStoryScale:
                self.windowManager.resizePreviewWindow()
                break
                
            case MonarchMethods.setDockSide:
                self.windowManager.setDocking()
                break
                
            case MonarchMethods.restartPreview:
                self.windowManager.restartPreviewWindow()
                break
                
            case MonarchMethods.terminatePreview:
                self.windowManager.terminate();
                break
                
            default:
                break
            }
        }
        
        self.previewWindowChannel.setMethodCallHandler {
            (call: FlutterMethodCall, callback:@escaping FlutterResult) -> Void in
            self.previewApiChannel.invokeMethod(call.method, arguments: call.arguments) {
                (result) -> Void in
                callback(result)
            }
        }
    }
    
    func unregisterMethodCallHandlers() {
        self.previewApiChannel.setMethodCallHandler(nil)
        self.previewWindowChannel.setMethodCallHandler(nil)
    }
    
    func getMonarchState(state:@escaping (MonarchState) -> Void) {
        self.previewApiChannel.invokeMethod(MonarchMethods.getState, arguments: nil) {
            (result) -> Void in
            let logger: Logger = Logger("MonarchState")
            if result is FlutterError {
                logger.severe("preview_api returned FlutterError while getting monarch state")
            }
            if result == nil {
                logger.severe("preview_api returned nil instead of monarch state")
            }
            let res = result as? [String: Any]
            state(MonarchState.init(standardMap: res!))
        }
    }
    
    func sendPreviewScreenChanged() {
        self.previewWindowChannel.invokeMethod(MonarchMethods.screenChanged, arguments: nil)
    }
    
    func sendControllerScreenChanged() {
        self.previewApiChannel.invokeMethod(MonarchMethods.screenChanged, arguments: nil)
    }
    
    func sendWillClosePreview() {
        self.previewWindowChannel.invokeMethod(MonarchMethods.willClosePreview, arguments: nil)
        self.previewApiChannel.invokeMethod(MonarchMethods.willClosePreview, arguments: nil)
    }
}

class MonarchMethods {
    static let setActiveDevice = "monarch.setActiveDevice"
    static let setStoryScale = "monarch.setStoryScale"
    static let setDockSide = "monarch.setDockSide"
    static let getState = "monarch.getState"
    static let screenChanged = "monarch.screenChanged"
    static let restartPreview = "monarch.restartPreview"
    static let willClosePreview = "monarch.willClosePreview"
    static let terminatePreview = "monarch.terminatePreview"
}

protocol ChannelArgument {}

protocol InboundChannelArgument : ChannelArgument {
    init(standardMap args : [String: Any]);
}
