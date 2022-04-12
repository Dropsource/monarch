//
//  AppDelegate.swift
//  monarch_macos
//
//  Created by Fernando Trigoso on 4/4/22.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // disables buffering so calls to println are flushed automatically
        // setbuf(__stdoutp, nil);
        // https://stackoverflow.com/questions/24171362/swift-how-to-flush-stdout-after-println
        
        let windowManager = WindowManager.init()
        windowManager.launchWindows()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }


}

