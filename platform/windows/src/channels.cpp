#include "channels.h"
#include <future>

Channels::Channels(
	flutter::BinaryMessenger* previewApiMessenger, 
	flutter::BinaryMessenger* previewWindowMessenger, 
	PreviewWindowManager* windowManager_)
{
	previewApiChannel = std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
		previewApiMessenger,
		previewApiChannelName,
		&flutter::StandardMethodCodec::GetInstance());

	previewWindowChannel = std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
		previewWindowMessenger,
		previewWindowChannelName,
		&flutter::StandardMethodCodec::GetInstance());

	windowManager = windowManager_;
}

Channels::~Channels()
{
	auto previewApiPtr = previewApiChannel.release();
	delete previewApiPtr;

	auto previewWindowPtr = previewWindowChannel.release();
	delete previewWindowPtr;
}

void Channels::setUpCallForwarding()
{
	previewWindowChannel->SetMethodCallHandler(
		[=](const auto& call, auto callback) {
			_forwardMethodCall(call, callback, previewApiChannel);
		}
	);

	previewApiChannel->SetMethodCallHandler(
		[=](const auto& call, auto callback) {
			_forwardMethodCall(call, callback, previewWindowChannel);

			if (call.method_name() == MonarchMethods::setActiveDevice ||
				call.method_name() == MonarchMethods::setStoryScale) {
				windowManager->resizePreviewWindow();
			}
			else if (call.method_name() == MonarchMethods::setDockSide) {
				windowManager->setDocking();
			}
			else if (call.method_name() == MonarchMethods::restartPreview) {
				windowManager->restartPreviewWindow();
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
	previewWindowChannel->InvokeMethod(MonarchMethods::willClosePreview, nullptr);
	previewApiChannel->InvokeMethod(MonarchMethods::willClosePreview, nullptr);
}

void Channels::unregisterMethodCallHandlers()
{
	previewApiChannel->SetMethodCallHandler(nullptr);
	previewWindowChannel->SetMethodCallHandler(nullptr);
}

void Channels::restartPreviewChannel(flutter::BinaryMessenger* previewMessenger)
{
	previewWindowChannel = std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
		previewMessenger,
		previewWindowChannelName,
		&flutter::StandardMethodCodec::GetInstance());
	setUpCallForwarding();
}
