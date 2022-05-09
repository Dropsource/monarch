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
    let previewChannel: FlutterMethodChannel
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
    
    func setUpCallForwarding() {
        self.controllerChannel.setMethodCallHandler {
            (call: FlutterMethodCall, result: FlutterResult) -> Void in
            self.previewChannel.invokeMethod(call.method, arguments: call.arguments)
            result(nil)
            
            switch (call.method) {
                
            case MonarchMethods.setActiveDevice,
                 MonarchMethods.setStoryScale:
                self.windowManager.resizePreviewWindow()
                break
                
            case MonarchMethods.setDockSide:
                self.windowManager.setDocking()
                break
                
            default:
                break
            }
        }
        
        self.previewChannel.setMethodCallHandler {
            (call: FlutterMethodCall, result: FlutterResult) -> Void in
            self.controllerChannel.invokeMethod(call.method, arguments: call.arguments)
            result(nil)
        }
    }
    
    func getMonarchState(state:@escaping (MonarchState)->()) {
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
}

class MonarchMethods {
    static let setActiveDevice = "monarch.setActiveDevice"
    static let setStoryScale = "monarch.setStoryScale"
    static let setDockSide = "monarch.setDockSide"
    static let getState = "monarch.getState"
}

protocol ChannelArgument {}

protocol InboundChannelArgument : ChannelArgument {
    init(standardMap args : [String: Any]);
}
