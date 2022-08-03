//
//  Channels.swift
//  monarch_macos
//
//  Created by Fernando Trigoso on 4/19/22.
//

import Foundation
import FlutterMacOS

class Channels {
    let controllerChannel: FlutterMethodChannel
    var previewChannel: FlutterMethodChannel
    let windowManager: WindowManager
    
    init(controllerMessenger: FlutterBinaryMessenger,
         previewMessenger: FlutterBinaryMessenger,
         windowManager: WindowManager) {
        self.controllerChannel = FlutterMethodChannel(
            name: "monarch.controller",
            binaryMessenger: controllerMessenger)
        self.previewChannel = FlutterMethodChannel(
            name: "monarch.preview",
            binaryMessenger: previewMessenger)
        self.windowManager = windowManager
    }
    
    func restartPreviewChannel(previewMessenger: FlutterBinaryMessenger) {
        self.unregisterMethodCallHandlers()
        self.previewChannel = FlutterMethodChannel(
            name: "monarch.preview",
            binaryMessenger: previewMessenger)
        self.setUpCallForwarding()
    }
    
    func setUpCallForwarding() {
        self.controllerChannel.setMethodCallHandler {
            (call: FlutterMethodCall, callback:@escaping FlutterResult) -> Void in
            self.previewChannel.invokeMethod(call.method, arguments: call.arguments) {
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
                
            default:
                break
            }
        }
        
        self.previewChannel.setMethodCallHandler {
            (call: FlutterMethodCall, callback:@escaping FlutterResult) -> Void in
            self.controllerChannel.invokeMethod(call.method, arguments: call.arguments) {
                (result) -> Void in
                callback(result)
            }
        }
    }
    
    func unregisterMethodCallHandlers() {
        self.controllerChannel.setMethodCallHandler(nil)
        self.previewChannel.setMethodCallHandler(nil)
    }
    
    func getMonarchState(state:@escaping (MonarchState) -> Void) {
        self.controllerChannel.invokeMethod(MonarchMethods.getState, arguments: nil) {
            (result) -> Void in
            let logger: Logger = Logger("MonarchState")
            if result is FlutterError {
                logger.severe("Controller returned FlutterError while getting monarch state")
            }
            if result == nil {
                logger.severe("Controller returned nil instead of monarch state")
            }
            let res = result as? [String: Any]
            state(MonarchState.init(standardMap: res!))
        }
    }
    
    func sendPreviewScreenChanged() {
        self.previewChannel.invokeMethod(MonarchMethods.screenChanged, arguments: nil)
    }
    
    func sendControllerScreenChanged() {
        self.controllerChannel.invokeMethod(MonarchMethods.screenChanged, arguments: nil)
    }
    
    func sendWillClosePreview() {
        self.previewChannel.invokeMethod(MonarchMethods.willClosePreview, arguments: nil)
        self.controllerChannel.invokeMethod(MonarchMethods.willClosePreview, arguments: nil)
    }
}

class MonarchMethods {
    static let setActiveDevice = "monarch.setActiveDevice"
    static let setStoryScale = "monarch.setStoryScale"
    static let setDockSide = "monarch.setDockSide"
    static let getState = "monarch.getState"
    static let screenChanged = "monarch.screenChanged"
    static let willClosePreview = "monarch.willClosePreview"
    static let restartPreview = "monarch.restartPreview"
}

protocol ChannelArgument {}

protocol InboundChannelArgument : ChannelArgument {
    init(standardMap args : [String: Any]);
}
