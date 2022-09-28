#include "window_manager.h"

#include <windows.h>
#include <stdlib.h>
#include <string.h>
#include <tchar.h>

#include <flutter/dart_project.h>
#include <flutter/flutter_view_controller.h>

#include "../gen/runner/utils.h"

#include "string_utils.h"
#include "logger.h"
#include "monarch_window.h"
#include "device_definition.h"


//WindowManager::WindowManager(
//	std::string controllerBundlePath, 
//	std::string previewBundlePath,
//	std::string defaultLogLevelString,
//	std::string cliGrpcServerPort,
//	std::string projectName)
//{
//	_controllerBundlePath = controllerBundlePath;
//	_previewBundlePath = previewBundlePath;
//	_defaultLogLevelString = defaultLogLevelString;
//	_cliGrpcServerPort = cliGrpcServerPort;
//	_projectName = projectName;
//
//	_controllerWindow = nullptr;
//	_previewWindow = nullptr;
//	_channels = nullptr;
//
//	selectedDockSide = DockSide::right;
//}
//
//WindowManager::~WindowManager()
//{
//	auto controllerPtr = _controllerWindow.release();
//	delete controllerPtr;
//
//	auto previewPtr = _previewWindow.release();
//	delete previewPtr;
//
//	auto channelsPtr = _channels.release();
//	delete channelsPtr;
//}
//
//// We open the Preview and then the Controller to make sure that DevTools
//// inspects the Preview.
//// Ideally we would want to open the Controller first and then the Preview.
//// However, if we open the Controller first, then DevTools inspects the
//// Controller.
//// We are waiting on the Flutter team to fix this issue:
//// https://github.com/flutter/devtools/issues/4304
//void WindowManager::launchWindows()
//{
//	flutter::DartProject controllerProject(to_wstring(_controllerBundlePath));
//	flutter::DartProject previewProject(to_wstring(_previewBundlePath));
//
//	std::vector<std::string> controllerArguments = { _defaultLogLevelString, _cliGrpcServerPort };
//	controllerProject.set_dart_entrypoint_arguments(controllerArguments);
//	std::vector<std::string> previewArguments = { _defaultLogLevelString };
//	previewProject.set_dart_entrypoint_arguments(previewArguments);
//
//	auto controllerWindowInfo = WindowInfo(Point_(200, 200), Size_(600, 700));
//
//	_previewWindow = std::make_unique<PreviewWindow>(
//		previewProject,
//		this);
//	_showAndSetUpPreviewWindow(controllerWindowInfo);
//
//	_controllerWindow = std::make_unique<ControllerWindow>(
//		controllerProject,
//		this);
//	_showAndSetUpControllerWindow(controllerWindowInfo);
//
//	_channels = std::make_unique<Channels>(
//		_controllerWindow->messenger(),
//		_previewWindow->messenger(),
//		this);
//	_channels->setUpCallForwarding();
//	
//	_controllerWindow->setPreviewWindow(_previewWindow->GetHandle());
//	_previewWindow->setControllerWindow(_controllerWindow->GetHandle());
//
//	Logger _logger{ L"WindowManager" };
//	_logger.info("monarch-window-manager-ready");
//}
//
//void WindowManager::_showAndSetUpPreviewWindow(WindowInfo controllerWindowInfo)
//{
//	auto previewSize = Win32Window::Size(
//		(long)defaultDeviceDefinition.logicalResolution.width,
//		(long)defaultDeviceDefinition.logicalResolution.height);
//
//	if (!_previewWindow->CreateAndShow(
//		to_wstring(defaultDeviceDefinition.title()),
//		Win32Window::Point(
//			controllerWindowInfo.topLeft.x + controllerWindowInfo.size.width,
//			controllerWindowInfo.topLeft.y),
//		previewSize)) {
//		throw std::runtime_error{ "Preview window was not created successfully" };
//	}
//
//	_previewWindow->SetQuitOnClose(true);
//	_previewWindow->disableResizeMinimize();
//	_previewWindow->resizeUsingClientRectOffset(
//		Size_(previewSize.width, previewSize.height),
//		defaultDockSide,
//		controllerWindowInfo);
//}
//
//void WindowManager::_showAndSetUpControllerWindow(WindowInfo controllerWindowInfo)
//{
//	// @GOTCHA: The Monarch CLI kills the controller window using its title.
//	// If you change the title, change the CLI as well.
//	if (!_controllerWindow->CreateAndShow(
//		to_wstring(_projectName) + L" - Monarch",
//		Win32Window::Point(controllerWindowInfo.topLeft.x, controllerWindowInfo.topLeft.y),
//		Win32Window::Size(controllerWindowInfo.size.width, controllerWindowInfo.size.height))) {
//		throw std::runtime_error{ "Controller window was not created successfully" };
//	}
//	_controllerWindow->SetQuitOnClose(true);
//}
//
//void WindowManager::resizePreviewWindow()
//{
//	auto result_handler = std::make_unique<flutter::MethodResultFunctions<>>(
//		[=](const EncodableValue* success_value) {
//			auto args = std::get<EncodableMap>(*success_value);
//			MonarchState state{ args };
//			resizePreviewWindow(state);
//		},
//		nullptr, nullptr);
//
//	_channels->controllerChannel->InvokeMethod(
//		MonarchMethods::getState, nullptr, std::move(result_handler));
//}
//
//void WindowManager::resizePreviewWindow(MonarchState state)
//{
//	_postMessageStateChange(state);
//}
//
//void WindowManager::setDocking()
//{
//	auto result_handler = std::make_unique<flutter::MethodResultFunctions<>>(
//		[=](const EncodableValue* success_value) {
//			auto args = std::get<EncodableMap>(*success_value);
//			MonarchState state{ args };
//			setDocking(state);
//		},
//		nullptr, nullptr);
//
//	_channels->controllerChannel->InvokeMethod(
//		MonarchMethods::getState, nullptr, std::move(result_handler));
//}
//
//void WindowManager::setDocking(MonarchState state)
//{
//	if (state.dock == DockSide::right) {
//		selectedDockSide = DockSide::right;
//		_postMessageStateChange(state);
//	}
//	else if (state.dock == DockSide::left) {
//		selectedDockSide = DockSide::left;
//		_postMessageStateChange(state);
//	}
//	else if (state.dock == DockSide::undock) {
//		selectedDockSide = DockSide::undock;
//		PostMessage(_previewWindow->GetHandle(), WM_M_UNDOCK, 0, 0);
//	}
//}
//
//void WindowManager::restartPreviewWindow()
//{
//	_channels->sendWillClosePreview();
//	_channels->unregisterMethodCallHandlers();
//
//	_previewWindow->SetQuitOnClose(false);
//	_previewWindow->Destroy();
//
//	flutter::DartProject previewProject(to_wstring(_previewBundlePath));
//	std::vector<std::string> previewArguments = { _defaultLogLevelString };
//	previewProject.set_dart_entrypoint_arguments(previewArguments);
//
//	_previewWindow = std::make_unique<PreviewWindow>(
//		previewProject,
//		this);
//
//	_showAndSetUpPreviewWindow(_controllerWindow->getWindowInfo());
//
//	_controllerWindow->setPreviewWindow(_previewWindow->GetHandle());
//	_previewWindow->setControllerWindow(_controllerWindow->GetHandle());
//
//	_channels->restartPreviewChannel(_previewWindow->messenger());
//	resizePreviewWindow();
//}
//
//void WindowManager::_postMessageStateChange(MonarchState state_)
//{
//	WindowInfo* windowInfo = new WindowInfo(_controllerWindow->getWindowInfo());
//	MonarchState* state = new MonarchState(state_);
//	PostMessage(_previewWindow->GetHandle(), WM_M_STATECHANGE, WPARAM(windowInfo), LPARAM(state));
//}


/////


HeadlessWindowManager::HeadlessWindowManager(
	std::string controllerBundlePath,
	std::string previewBundlePath,
	std::string defaultLogLevelString,
	std::string cliGrpcServerPort,
	std::string projectName)
{
	_controllerBundlePath = controllerBundlePath;
	_previewBundlePath = previewBundlePath;
	_defaultLogLevelString = defaultLogLevelString;
	_cliGrpcServerPort = cliGrpcServerPort;
	_projectName = projectName;

	_headlessController = nullptr;
	_previewWindow = nullptr;
	_channels = nullptr;

	selectedDockSide = DockSide::right;
}

HeadlessWindowManager::~HeadlessWindowManager()
{
	auto controllerPtr = _headlessController.release();
	delete controllerPtr;

	auto previewPtr = _previewWindow.release();
	delete previewPtr;

	auto channelsPtr = _channels.release();
	delete channelsPtr;
}

void HeadlessWindowManager::launchWindows()
{
	flutter::DartProject controllerProject(to_wstring(_controllerBundlePath));
	flutter::DartProject previewProject(to_wstring(_previewBundlePath));

	std::vector<std::string> controllerArguments = { _defaultLogLevelString, _cliGrpcServerPort };
	controllerProject.set_dart_entrypoint_arguments(controllerArguments);
	std::vector<std::string> previewArguments = { _defaultLogLevelString };
	previewProject.set_dart_entrypoint_arguments(previewArguments);

	auto controllerWindowInfo = WindowInfo(Point_(200, 200), Size_(600, 700));

	_previewWindow = std::make_unique<PreviewWindow>(
		previewProject,
		this);
	_showAndSetUpPreviewWindow(controllerWindowInfo);

	_headlessController = std::make_unique<HeadlessController>(
		controllerProject,
		this);
	_headlessController->create();
	//_showAndSetUpControllerWindow(controllerWindowInfo);

	_channels = std::make_unique<Channels>(
		_headlessController->engine()->messenger(),
		_previewWindow->messenger(),
		this);
	_channels->setUpCallForwarding();

	//_controllerWindow->setPreviewWindow(_previewWindow->GetHandle());
	//_previewWindow->setControllerWindow(_controllerWindow->GetHandle());

	Logger _logger{ L"HeadlessWindowManager" };
	_logger.info("monarch-window-manager-ready");
}

void HeadlessWindowManager::_showAndSetUpPreviewWindow(WindowInfo controllerWindowInfo)
{
	auto previewSize = Win32Window::Size(
		(long)defaultDeviceDefinition.logicalResolution.width,
		(long)defaultDeviceDefinition.logicalResolution.height);

	if (!_previewWindow->CreateAndShow(
		to_wstring(defaultDeviceDefinition.title()),
		Win32Window::Point(
			controllerWindowInfo.topLeft.x + controllerWindowInfo.size.width,
			controllerWindowInfo.topLeft.y),
		previewSize)) {
		throw std::runtime_error{ "Preview window was not created successfully" };
	}

	_previewWindow->SetQuitOnClose(true);
	_previewWindow->disableResizeMinimize();
	_previewWindow->resizeUsingClientRectOffset(
		Size_(previewSize.width, previewSize.height),
		defaultDockSide,
		controllerWindowInfo);
}

void HeadlessWindowManager::resizePreviewWindow()
{
	auto result_handler = std::make_unique<flutter::MethodResultFunctions<>>(
		[=](const EncodableValue* success_value) {
			auto args = std::get<EncodableMap>(*success_value);
			MonarchState state{ args };
			resizePreviewWindow(state);
		},
		nullptr, nullptr);

	_channels->controllerChannel->InvokeMethod(
		MonarchMethods::getState, nullptr, std::move(result_handler));
}

void HeadlessWindowManager::resizePreviewWindow(MonarchState state)
{
	_postMessageStateChange(state);
}

void HeadlessWindowManager::setDocking()
{
	auto result_handler = std::make_unique<flutter::MethodResultFunctions<>>(
		[=](const EncodableValue* success_value) {
			auto args = std::get<EncodableMap>(*success_value);
			MonarchState state{ args };
			setDocking(state);
		},
		nullptr, nullptr);

	_channels->controllerChannel->InvokeMethod(
		MonarchMethods::getState, nullptr, std::move(result_handler));
}

void HeadlessWindowManager::setDocking(MonarchState state)
{
	if (state.dock == DockSide::right) {
		selectedDockSide = DockSide::right;
		_postMessageStateChange(state);
	}
	else if (state.dock == DockSide::left) {
		selectedDockSide = DockSide::left;
		_postMessageStateChange(state);
	}
	else if (state.dock == DockSide::undock) {
		selectedDockSide = DockSide::undock;
		PostMessage(_previewWindow->GetHandle(), WM_M_UNDOCK, 0, 0);
	}
}

void HeadlessWindowManager::restartPreviewWindow()
{
	/*_channels->sendWillClosePreview();
	_channels->unregisterMethodCallHandlers();

	_previewWindow->SetQuitOnClose(false);
	_previewWindow->Destroy();

	flutter::DartProject previewProject(to_wstring(_previewBundlePath));
	std::vector<std::string> previewArguments = { _defaultLogLevelString };
	previewProject.set_dart_entrypoint_arguments(previewArguments);

	_previewWindow = std::make_unique<PreviewWindow>(
		previewProject,
		this);

	_showAndSetUpPreviewWindow(_controllerWindow->getWindowInfo());

	_controllerWindow->setPreviewWindow(_previewWindow->GetHandle());
	_previewWindow->setControllerWindow(_controllerWindow->GetHandle());

	_channels->restartPreviewChannel(_previewWindow->messenger());
	resizePreviewWindow();*/
}

void HeadlessWindowManager::_postMessageStateChange(MonarchState state_)
{
	/*WindowInfo* windowInfo = new WindowInfo(_controllerWindow->getWindowInfo());
	MonarchState* state = new MonarchState(state_);
	PostMessage(_previewWindow->GetHandle(), WM_M_STATECHANGE, WPARAM(windowInfo), LPARAM(state));*/
}
