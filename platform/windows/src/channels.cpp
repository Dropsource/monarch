#include "channels.h"
#include <future>

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
		[=](const auto& call, auto callback) {
			_forwardMethodCall(call, callback, controllerChannel);
		}
	);

	controllerChannel->SetMethodCallHandler(
		[=](const auto& call, auto callback) {
			_forwardMethodCall(call, callback, previewChannel);

			if (call.method_name() == MonarchMethods::setActiveDevice ||
				call.method_name() == MonarchMethods::setStoryScale) {
				windowManager->resizePreviewWindow();
			}
			else if (call.method_name() == MonarchMethods::setDockSide) {
				windowManager->setDocking();
			}
			else if (call.method_name() == MonarchMethods::restartPreview) {
				windowManager->restartPreviewWindow();
				//auto fut = std::async(windowManager->restartPreviewWindow, void);

				// NEXT: send post message instead
				//auto fut = std::async([=] {return windowManager->restartPreviewWindow(); });
			}
			else {
				// no-op
			}
		}
	);
}

void Channels::_forwardMethodCall(
	const flutter::MethodCall<EncodableValue>& call, 
	std::unique_ptr<flutter::MethodResult<EncodableValue>>& callback, 
	std::unique_ptr<flutter::MethodChannel<EncodableValue>>& forwardChannel)
{
	std::shared_ptr<flutter::MethodResult<>> _callback(callback.release());
	auto success_handler = [_callback](const EncodableValue* success_value) {
		if (success_value == nullptr || success_value->IsNull()) {
			_callback->Success();
		}
		else {
			_callback->Success(*success_value);
		}
	};

	auto error_handler = [_callback](
		const std::string& error_code,
		const std::string& error_message,
		const EncodableValue* error_details) {
			if (error_details == nullptr || error_details->IsNull()) {
				_callback->Error(error_code, error_message);
			}
			else {
				_callback->Error(error_code, error_message, *error_details);
			}
	};

	auto not_implemented_handler = [_callback]() {
		_callback->NotImplemented();
	};

	if (std::holds_alternative<std::monostate>(*call.arguments())) {
		forwardChannel->InvokeMethod(
			call.method_name(),
			std::make_unique<EncodableValue>(std::monostate()),
			std::make_unique<flutter::MethodResultFunctions<>>(
				success_handler,
				error_handler,
				not_implemented_handler));
	}
	else {
		forwardChannel->InvokeMethod(
			call.method_name(),
			std::make_unique<EncodableValue>(
				EncodableValue(std::get<EncodableMap>(*call.arguments()))),
			std::make_unique<flutter::MethodResultFunctions<>>(
				success_handler,
				error_handler,
				not_implemented_handler));
	}
}

void Channels::sendWillClosePreview()
{
	previewChannel->InvokeMethod(MonarchMethods::willClosePreview, nullptr);
	controllerChannel->InvokeMethod(MonarchMethods::willClosePreview, nullptr);
}

void Channels::unregisterMethodCallHandlers()
{
	controllerChannel->SetMethodCallHandler(nullptr);
	previewChannel->SetMethodCallHandler(nullptr);
}

void Channels::restartPreviewChannel(flutter::BinaryMessenger* previewMessenger)
{
	previewChannel = std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
		previewMessenger,
		previewChannelName,
		&flutter::StandardMethodCodec::GetInstance());
	setUpCallForwarding();
}
