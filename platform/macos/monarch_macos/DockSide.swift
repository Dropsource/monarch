//
//  DockSide.swift
//  monarch
//
//  Created by Fernando Trigoso on 8/12/21.
//  Copyright © 2021 Fernando Trigoso. All rights reserved.
//

import Foundation

enum DockSide {
    case right, left, undock
}

let defaultDockSide: DockSide = .right

func dockFromString(dockString: String) -> DockSide {
    switch dockString {
    case "left":
        return .left
    case "right":
        return .right
    case "undock":
        return .undock
    default:
        return .right
    }
}
