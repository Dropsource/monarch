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


WindowManager::WindowManager(
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

	_controllerWindow = nullptr;
	_previewWindow = nullptr;
	_channels = nullptr;

	selectedDockSide = DockSide::right;
}

WindowManager::~WindowManager()
{
	auto controllerPtr = _controllerWindow.release();
	delete controllerPtr;

	auto previewPtr = _previewWindow.release();
	delete previewPtr;

	auto channelsPtr = _channels.release();
	delete channelsPtr;
}

void WindowManager::launchWindows()
{
	flutter::DartProject controllerProject(to_wstring(_controllerBundlePath));
	flutter::DartProject previewProject(to_wstring(_previewBundlePath));

	std::vector<std::string> controllerArguments = { _defaultLogLevelString, _cliGrpcServerPort };
	controllerProject.set_dart_entrypoint_arguments(controllerArguments);
	std::vector<std::string> previewArguments = { _defaultLogLevelString };
	previewProject.set_dart_entrypoint_arguments(previewArguments);

	_controllerWindow = std::make_unique<ControllerWindow>(
		controllerProject, 
		this);	

	if (!_controllerWindow->CreateAndShow(
		L"Monarch", 
		Win32Window::Point(200, 200), 
		Win32Window::Size(600, 700))) {
		throw std::runtime_error{ "Controller window was not created successfully" };
	}
	_controllerWindow->SetQuitOnClose(true);	

	_previewWindow = std::make_unique<PreviewWindow>(
		previewProject,
		this,
		_controllerWindow->GetHandle());
	_setUpPreviewWindow();

	_channels = std::make_unique<Channels>(
		_controllerWindow->messenger(),
		_previewWindow->messenger(),
		this);
	_channels->setUpCallForwarding();
	

	Logger _logger{ L"WindowManager" };
	_logger.info("monarch-window-manager-ready");
}

void WindowManager::_setUpPreviewWindow()
{
	auto controllerWindowInfo = _controllerWindow->getWindowInfo();
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

	_controllerWindow->setPreviewWindow(_previewWindow->GetHandle());
}

void WindowManager::resizePreviewWindow()
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

void WindowManager::resizePreviewWindow(MonarchState state)
{
	_postMessageStateChange(state);
}

void WindowManager::setDocking()
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

void WindowManager::setDocking(MonarchState state)
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

void WindowManager::restartPreviewWindow()
{
	_channels->sendWillClosePreview();
	_channels->unregisterMethodCallHandlers();

	_previewWindow->SetQuitOnClose(false);
	_previewWindow->Destroy();

	flutter::DartProject previewProject(to_wstring(_previewBundlePath));
	std::vector<std::string> previewArguments = { _defaultLogLevelString };
	previewProject.set_dart_entrypoint_arguments(previewArguments);

	_previewWindow = std::make_unique<PreviewWindow>(
		previewProject,
		this,
		_controllerWindow->GetHandle());

	_setUpPreviewWindow();
	_channels->restartPreviewChannel(_previewWindow->messenger());
	resizePreviewWindow();
}

void WindowManager::_postMessageStateChange(MonarchState state_)
{
	WindowInfo* windowInfo = new WindowInfo(_controllerWindow->getWindowInfo());
	MonarchState* state = new MonarchState(state_);
	PostMessage(_previewWindow->GetHandle(), WM_M_STATECHANGE, WPARAM(windowInfo), LPARAM(state));
}
