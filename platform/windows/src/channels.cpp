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
		//[=](const flutter::MethodCall<>& call, std::unique_ptr<flutter::MethodResult<>> callback){
		[=](const auto& call, auto callback) {
			
			
			//auto _callback = std::move(callback);
			std::shared_ptr<flutter::MethodResult<>> _callback(callback.release());
			
			
			auto success_handler = [_callback](const EncodableValue* success_value) mutable {
				if (success_value == nullptr || success_value->IsNull()) {
					_callback->Success();
				}
				else {
					_callback->Success(success_value);
				}
			};

			//auto forward_result_handler = std::make_unique<flutter::MethodResultFunctions<>>(
				//success_handler,
				//nullptr,
				//nullptr);

			if (std::holds_alternative<std::monostate>(*call.arguments())) {
				controllerChannel->InvokeMethod(
					call.method_name(),
					std::make_unique<EncodableValue>(std::monostate()),
					std::make_unique<flutter::MethodResultFunctions<>>(
						success_handler,
						nullptr,
						nullptr));
			}
			else {	
				controllerChannel->InvokeMethod(
					call.method_name(),
					std::make_unique<EncodableValue>(
						EncodableValue(std::get<EncodableMap>(*call.arguments()))),
					std::make_unique<flutter::MethodResultFunctions<>>(
						success_handler,
						nullptr,
						nullptr));
			}
		}
	);

	controllerChannel->SetMethodCallHandler(
		//[=](const flutter::MethodCall<>& call, std::unique_ptr<flutter::MethodResult<>> callback) {
		[=](const auto& call, auto callback) {
			//auto _callback = std::move(callback);
			std::shared_ptr<flutter::MethodResult<>> _callback(callback.release());
			auto forward_result_handler = std::make_unique<flutter::MethodResultFunctions<>>(
				[_callback](const EncodableValue* success_value) {
					//if (success_value == nullptr || std::holds_alternative<std::monostate>(*success_value)) {
						//callback->Success();
					//}
					if (success_value == nullptr || success_value->IsNull()) {
						_callback->Success();
					}
					else {
						_callback->Success(success_value);
					}
				},
				nullptr,
				nullptr);

			if (std::holds_alternative<std::monostate>(*call.arguments())) {
				previewChannel->InvokeMethod(
					call.method_name(),
					std::make_unique<EncodableValue>(std::monostate()),
					std::move(forward_result_handler));
			}
			else {
				previewChannel->InvokeMethod(
					call.method_name(),
					std::make_unique<EncodableValue>(
						EncodableValue(std::get<EncodableMap>(*call.arguments()))),
					std::move(forward_result_handler));
			}
			

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
