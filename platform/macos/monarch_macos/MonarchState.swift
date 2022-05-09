//
//  MonarchState.swift
//  monarch_macos
//
//  Created by Fernando Trigoso on 5/9/22.
//

import Foundation

struct MonarchState {
    let device: DeviceDefinition
    let scale: ScaleDefinition
    let dock: DockSide

    
    init(device: DeviceDefinition, scale: ScaleDefinition, dock: DockSide) {
        self.device = device
        self.scale = scale
        self.dock = dock
    }
}

extension MonarchState : InboundChannelArgument {
    
    init(standardMap args: [String : Any]) {
        self.init(
            device: DeviceDefinition.init(standardMap: args["device"] as! [String : Any]),
            scale: ScaleDefinition.init(standardMap: args["scale"] as! [String: Any]),
            dock: dockFromString(dockString: args["dock"] as! String)
        )
    }
}
