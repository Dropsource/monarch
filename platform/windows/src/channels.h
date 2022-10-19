#pragma once

#include <string>
#include <flutter/method_channel.h>
#include <flutter/standard_method_codec.h>
#include <flutter/method_result_functions.h>

#include "window_manager.h"
#include "monarch_state.h"
#include "channels_utils.h"

class PreviewWindowManager;

const std::string previewApiChannelName = "monarch.previewApi";
const std::string previewWindowChannelName = "monarch.previewWindow";

class Channels
{
public:
	Channels(
		flutter::BinaryMessenger* previewServerMessenger,
		flutter::BinaryMessenger* previewWindowMessenger,
		PreviewWindowManager* windowManager_);
	~Channels();

	void setUpCallForwarding();
	void sendWillClosePreview();
	void unregisterMethodCallHandlers();
	void restartPreviewChannel(flutter::BinaryMessenger* previewMessenger);

	std::unique_ptr<flutter::MethodChannel<EncodableValue>> previewApiChannel;
	std::unique_ptr<flutter::MethodChannel<EncodableValue>> previewWindowChannel;
	PreviewWindowManager* previewWindowManager;

private:
	void _forwardMethodCall(
		const flutter::MethodCall<EncodableValue>& call,
		std::unique_ptr<flutter::MethodResult<EncodableValue>>& callback ,
		std::unique_ptr<flutter::MethodChannel<EncodableValue>>& forwardChannel);
};

namespace MonarchMethods
{
	const std::string setActiveDevice = "monarch.setActiveDevice";
	const std::string setStoryScale = "monarch.setStoryScale";
	const std::string setDockSide = "monarch.setDockSide";
	const std::string getState = "monarch.getState";
	const std::string screenChanged = "monarch.screenChanged";
	const std::string restartPreview = "monarch.restartPreview";
	const std::string willClosePreview = "monarch.willClosePreview";
	const std::string terminatePreview = "monarch.terminatePreview";
};

