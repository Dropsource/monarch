//
//  ScaleDefinition.swift
//  monarch_macos
//
//  Created by Fernando Trigoso on 5/9/22.
//

import Foundation

struct ScaleDefinition {
    let name: String
    let scale: Double
    
    init(name: String, scale: Double) {
        self.name = name
        self.scale = scale
    }
}

extension ScaleDefinition : InboundChannelArgument {
    
    init(standardMap args: [String : Any]) {
        self.init(
            name: args["name"] as! String,
            scale: args["scale"] as! Double
        )
    }
}

let defaultScaleDefinition: ScaleDefinition = ScaleDefinition.init(
    name: "100%",
    scale: 1.0)
