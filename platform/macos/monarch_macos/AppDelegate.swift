//
//  AppDelegate.swift
//  monarch_macos
//
//  Created by Fernando Trigoso on 4/4/22.
//

import Cocoa
import FlutterMacOS


#if USE_FLUTTER_APP_DELEGATE
@main
class AppDelegate: FlutterAppDelegate {

    override func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        let windowManager = WindowManager.init(flutterAppDelete: self)
        windowManager.launchWindows()
        
        self.mainFlutterWindow?.close()
    }
    
    override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }

}
#else
@main
class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ aNotification: Notification) {
    
        let windowManager = WindowManager.init()
        windowManager.launchWindows()
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }

}
#endif
