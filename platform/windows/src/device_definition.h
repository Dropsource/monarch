#pragma once

#include <string>
#include "logical_resolution.h"
#include "channels_utils.h"

enum class TargetPlatform {
	ios, android
};

TargetPlatform targetPlatformFromString(std::string platform);

struct DeviceDefinition {
	std::string id;
	std::string name;
	LogicalResolution logicalResolution;
	double devicePixelRatio;
	TargetPlatform targetPlatform;

	DeviceDefinition();

	DeviceDefinition(
		std::string _id,
		std::string _name,
		LogicalResolution _logicalResolution,
		double _devicePixelRatio,
		TargetPlatform _targetPlatform);

	DeviceDefinition(flutter::EncodableMap args);

	std::string title();
};

extern DeviceDefinition defaultDeviceDefinition;
