import Foundation

private let _ios : String = "ios";
private let _android : String = "android";

enum TargetPlatform {
    case ios
    case android
}

func targetPlatformFromString(platform: String) -> TargetPlatform {
    return platform == _ios ? .ios : .android;
}

struct DeviceDefinition {
    let id: String
    let name: String
    let logicalResolution: LogicalResolution
    let devicePixelRatio: Double
    let targetPlatform: TargetPlatform

    
    init(id: String, name: String, logicalResolution: LogicalResolution, devicePixelRatio: Double, targetPlatform: TargetPlatform) {
        self.id = id
        self.name = name
        self.logicalResolution = logicalResolution
        self.devicePixelRatio = devicePixelRatio
        self.targetPlatform = targetPlatform
    }
    
    var title: String {
        get {
            let _width = String(format: "%.0f", self.logicalResolution.width)
            let _height = String(format: "%.0f", self.logicalResolution.height)
            return  "\(self.name) | \(_width)x\(_height)"
        }
    }
}

extension DeviceDefinition : InboundChannelArgument {
    
    init(standardMap args: [String : Any]) {
        self.init(
            id: args["id"] as! String,
            name: args["name"] as! String,
            logicalResolution: LogicalResolution.init(standardMap: args["logicalResolution"] as! [String : Any]),
            devicePixelRatio: args["devicePixelRatio"] as! Double,
            targetPlatform: targetPlatformFromString(platform: args["targetPlatform"] as! String)
        )
    }
}

func getDeviceDefinitions(standardMap args: [String: Any]) -> [DeviceDefinition] {
    let definitionsArg = args["definitions"] as! [[String: Any]]
    return definitionsArg.map({
        DeviceDefinition(standardMap: $0)
    })
}

let iPhone13DeviceDefinition: DeviceDefinition = DeviceDefinition.init(
    id: "ios-iphone-13",
    name: "iPhone 13",
    logicalResolution: LogicalResolution.init(width: 390, height: 844),
    devicePixelRatio: 3.0,
    targetPlatform: .ios)

let defaultDeviceDefinition = iPhone13DeviceDefinition

protocol ChannelArgument {}

protocol InboundChannelArgument : ChannelArgument {
    init(standardMap args : [String: Any]);
}
