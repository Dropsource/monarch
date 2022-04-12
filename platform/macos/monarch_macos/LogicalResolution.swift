//
//  LogicalResolution.swift
//  monarch
//
//  Created by Fernando Trigoso on 4/22/20.
//  Copyright © 2020 Fernando Trigoso. All rights reserved.
//

import Foundation

struct LogicalResolution {
    let width: Double
    let height: Double
    
    init(width: Double, height: Double) {
        self.width = width
        self.height = height
    }
    
    var size: NSSize {
        get {
            return NSSize(width: self.width, height: self.height)
        }
    }
}

extension LogicalResolution : InboundChannelArgument {
    init(standardMap args: [String : Any]) {
        let width = args["width"] as! Double
        let height = args["height"] as! Double
        self.init(width: width, height: height)
    }
}
