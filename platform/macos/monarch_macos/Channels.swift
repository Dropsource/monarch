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
    
    init(controllerMessenger: FlutterBinaryMessenger, previewMessenger: FlutterBinaryMessenger) {
        self.controllerChannel = FlutterMethodChannel(
            name: "monarch.controller",
            binaryMessenger: controllerMessenger)
        self.previewChannel = FlutterMethodChannel(
            name: "monarch.preview",
            binaryMessenger: previewMessenger)
    }
    
    func setUpCallForwarding() {
        self.controllerChannel.setMethodCallHandler {
            (call: FlutterMethodCall, result: FlutterResult) -> Void in
            self.previewChannel.invokeMethod(call.method, arguments: call.arguments)
            result(nil)
        }
        
        self.previewChannel.setMethodCallHandler {
            (call: FlutterMethodCall, result: FlutterResult) -> Void in
            self.controllerChannel.invokeMethod(call.method, arguments: call.arguments)
            result(nil)
        }
    }
}
