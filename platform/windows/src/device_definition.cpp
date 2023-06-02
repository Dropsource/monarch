#include "device_definition.h"
#include "channels.h"
#include "logical_resolution.h"

TargetPlatform targetPlatformFromString(std::string platform)
{
	return platform == "ios" ? TargetPlatform::ios : TargetPlatform::android;
}

DeviceDefinition::DeviceDefinition()
{
	id = defaultDeviceDefinition.id;
	name = defaultDeviceDefinition.name;
	logicalResolution = defaultDeviceDefinition.logicalResolution;
	devicePixelRatio = defaultDeviceDefinition.devicePixelRatio;
	targetPlatform = defaultDeviceDefinition.targetPlatform;
}

DeviceDefinition::DeviceDefinition(std::string _id, std::string _name,
	LogicalResolution _logicalResolution, double _devicePixelRatio, 
	TargetPlatform _targetPlatform)
{
	id = _id;
	name = _name;
	logicalResolution = _logicalResolution;
	devicePixelRatio = _devicePixelRatio;
	targetPlatform = _targetPlatform;
}

DeviceDefinition::DeviceDefinition(EncodableMap args)
{
	id = std::get<std::string>(MapUtils::getValue(args, "id"));
	name = std::get<std::string>(MapUtils::getValue(args, "name"));
	logicalResolution = LogicalResolution{ std::get<EncodableMap>(MapUtils::getValue(args, "logicalResolution")) };
	devicePixelRatio = std::get<double>(MapUtils::getValue(args, "devicePixelRatio"));
	targetPlatform = targetPlatformFromString(std::get<std::string>(MapUtils::getValue(args, "targetPlatform")));
}

std::string DeviceDefinition::title()
{
	const auto width = std::to_string((int)logicalResolution.width);
	const auto height = std::to_string((int)logicalResolution.height);
	return width + "x" + height + " | " + name;
}

DeviceDefinition defaultDeviceDefinition = DeviceDefinition{
	"ios-iphone-14", 
	"iPhone 14", 
	LogicalResolution{390.0, 844.0},
	3.0,
	TargetPlatform::ios };
