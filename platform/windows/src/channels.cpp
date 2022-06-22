#include "channels.h"

Channels::Channels(
	flutter::BinaryMessenger* controllerMessenger, 
	flutter::BinaryMessenger* previewMessenger, 
	WindowManager* windowManager_)
{
	controllerChannel = std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
		controllerMessenger,
		controllerChannelName,
		&flutter::StandardMethodCodec::GetInstance());

	previewChannel = std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
		previewMessenger,
		previewChannelName,
		&flutter::StandardMethodCodec::GetInstance());

	windowManager = windowManager_;
}

Channels::~Channels()
{
	auto controllerPtr = controllerChannel.release();
	delete controllerPtr;

	auto previewPtr = previewChannel.release();
	delete previewPtr;
}

void Channels::setUpCallForwarding()
{
	previewChannel->SetMethodCallHandler(
		[=](const auto& call, auto result) {
			if (std::holds_alternative<std::monostate>(*call.arguments())) {
				controllerChannel->InvokeMethod(
					call.method_name(),
					std::make_unique<EncodableValue>(std::monostate()));
			}
			else {	
				controllerChannel->InvokeMethod(
					call.method_name(),
					std::make_unique<EncodableValue>(
						EncodableValue(std::get<EncodableMap>(*call.arguments()))));
			}
			result->Success();
		}
	);

	controllerChannel->SetMethodCallHandler(
		[=](const auto& call, auto result) {
			if (std::holds_alternative<std::monostate>(*call.arguments())) {
				previewChannel->InvokeMethod(
					call.method_name(),
					std::make_unique<EncodableValue>(std::monostate()));
			}
			else {
				previewChannel->InvokeMethod(
					call.method_name(),
					std::make_unique<EncodableValue>(
						EncodableValue(std::get<EncodableMap>(*call.arguments()))));
			}
			
			result->Success();

			if (call.method_name() == MonarchMethods::setActiveDevice ||
				call.method_name() == MonarchMethods::setStoryScale) {
				
				auto result_handler = std::make_unique<flutter::MethodResultFunctions<>>(
					[=](const EncodableValue* success_value) {
						auto args = std::get<EncodableMap>(*success_value);
						MonarchState state{ args };
						windowManager->resizePreviewWindow(state);
					},
					nullptr, nullptr);

				controllerChannel->InvokeMethod(
					MonarchMethods::getState, nullptr, std::move(result_handler));
			}
			else if (call.method_name() == MonarchMethods::setDockSide) {
				auto result_handler = std::make_unique<flutter::MethodResultFunctions<>>(
					[=](const EncodableValue* success_value) {
						auto args = std::get<EncodableMap>(*success_value);
						MonarchState state{ args };
						windowManager->setDocking(state);
					},
					nullptr, nullptr);

				controllerChannel->InvokeMethod(
					MonarchMethods::getState, nullptr, std::move(result_handler));
			}
			else {
				// no-op
			}
		}
	);
}
