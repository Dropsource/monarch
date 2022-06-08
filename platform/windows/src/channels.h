#pragma once

#include <string>
#include <flutter/method_channel.h>
#include <flutter/standard_method_codec.h>

#include "window_manager.h"
#include "monarch_state.h"
#include "channels_utils.h"

class WindowManager;

const std::string controllerChannelName = "monarch.controller";
const std::string previewChannelName = "monarch.preview";

class Channels
{
public:
	Channels(
		flutter::BinaryMessenger* controllerMessenger,
		flutter::BinaryMessenger* previewMessenger,
		WindowManager* windowManager_);
	~Channels();

	void setUpCallForwarding();

	std::unique_ptr<flutter::MethodChannel<EncodableValue>> controllerChannel;
	std::unique_ptr<flutter::MethodChannel<EncodableValue>> previewChannel;
	WindowManager* windowManager;
};

namespace MonarchMethods
{
	const std::string setActiveDevice = "monarch.setActiveDevice";
	const std::string setStoryScale = "monarch.setStoryScale";
	const std::string setDockSide = "monarch.setDockSide";
	const std::string getState = "monarch.getState";
	const std::string screenChanged = "monarch.screenChanged";
};

