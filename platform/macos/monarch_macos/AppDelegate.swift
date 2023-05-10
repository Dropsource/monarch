//
//  AppDelegate.swift
//  monarch_macos
//
//  Created by Fernando Trigoso on 4/4/22.
//

import Cocoa
import FlutterMacOS

@main
class AppDelegate: FlutterAppDelegate {

    override func applicationDidFinishLaunching(_ aNotification: Notification) {
        // disables buffering so calls to println are flushed automatically
        // setbuf(__stdoutp, nil);
        // https://stackoverflow.com/questions/24171362/swift-how-to-flush-stdout-after-println
        
        let windowManager = WindowManager.init()
        windowManager.launchWindows()
    }
    
    override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }

}

