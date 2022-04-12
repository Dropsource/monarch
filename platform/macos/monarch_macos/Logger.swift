//
//  Logger.swift
//  monarch
//
//  Created by Fernando Trigoso on 5/6/20.
//  Copyright © 2020 Fernando Trigoso. All rights reserved.
//

import Foundation

func printMessage(_ message: String) {
    print("mac_app: \(message)")
}

enum LogLevel : Int {
    case ALL = 0
    case FINEST = 300
    case FINER = 400
    case FINE = 500
    case CONFIG = 700
    case INFO = 800
    case WARNING = 900
    case SEVERE = 1000
    case SHOUT = 1200
    case OFF = 2000
}

func logLevelFromString(levelString: String) -> LogLevel {
    switch levelString {
    case "ALL":
        return LogLevel.ALL
    case "FINEST":
        return LogLevel.FINEST
    case "FINER":
        return LogLevel.FINER
    case "FINE":
        return LogLevel.FINE
    case "CONFIG":
        return LogLevel.CONFIG
    case "INFO":
        return LogLevel.INFO
    case "WARNING":
        return LogLevel.WARNING
    case "SEVERE":
        return LogLevel.SEVERE
    case "SHOUT":
        return LogLevel.SHOUT
    case "OFF":
        return LogLevel.OFF
    default:
        return LogLevel.ALL
    }
}

func logLevelToString(level: LogLevel) -> String {
    switch level {
    case LogLevel.ALL:
        return "ALL";
    case LogLevel.FINEST:
        return "FINEST"
    case LogLevel.FINER:
        return "FINER"
    case LogLevel.FINE:
        return "FINE"
    case LogLevel.CONFIG:
        return "CONFIG"
    case LogLevel.INFO:
        return "INFO"
    case LogLevel.WARNING:
        return "WARNING"
    case LogLevel.SEVERE:
        return "SEVERE"
    case LogLevel.SHOUT:
        return "SHOUT"
    case LogLevel.OFF:
        return "OFF"
    }
}

var defaultLogLevel: LogLevel = LogLevel.ALL


class Logger {
    let name: String
    
    var _level: LogLevel?
    
    var level: LogLevel {
        get {
            return _level ?? defaultLogLevel
        }
        set (newLevel) {
            _level = newLevel
        }
    }
    
    init(_ name: String) {
        self.name = name
    }
    
    func isLoggable(_ value: LogLevel) -> Bool {
        return value.rawValue >= level.rawValue
    }
    
    func log(_ logLevel: LogLevel, _ message: String) {
        if (isLoggable(logLevel)) {
            let levelString = logLevelToString(level: logLevel)
            printMessage("\(levelString) [\(name)] \(message)")
        }
    }
    
    func finest(_ message: String) {
        self.log(LogLevel.FINEST, message);
    }

    func finer(_ message: String) {
        self.log(LogLevel.FINER, message);
    }

    func fine(_ message: String) {
        self.log(LogLevel.FINE, message);
    }

    func config(_ message: String) {
        self.log(LogLevel.CONFIG, message);
    }

    func info(_ message: String) {
        self.log(LogLevel.INFO, message);
    }

    func warning(_ message: String) {
        self.log(LogLevel.WARNING, message);
    }

    func severe(_ message: String) {
        self.log(LogLevel.SEVERE, message);
    }

    func shout(_ message: String) {
        self.log(LogLevel.SHOUT, message);
    }

}
