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


/// ControllerWindowManager

ControllerWindowManager::ControllerWindowManager(
	std::string controllerWindowBundlePath,
	std::string defaultLogLevelString,
	std::string cliGrpcServerPort,
	std::string projectName)
{
	_controllerWindowBundlePath = controllerWindowBundlePath;
	_defaultLogLevelString = defaultLogLevelString;
	_cliGrpcServerPort = cliGrpcServerPort;
	_projectName = projectName;

	_controllerWindow = nullptr;
}

ControllerWindowManager::~ControllerWindowManager()
{
	auto controllerPtr = _controllerWindow.release();
	delete controllerPtr;
}

void ControllerWindowManager::launchWindow()
{
	flutter::DartProject controllerProject(to_wstring(_controllerWindowBundlePath));

	std::vector<std::string> controllerArguments = { _defaultLogLevelString, _cliGrpcServerPort };
	controllerProject.set_dart_entrypoint_arguments(controllerArguments);

	_controllerWindow = std::make_unique<ControllerWindow>(controllerProject);
	_showAndSetUpControllerWindow(ControllerWindow::defaultWindowInfo);

	Logger _logger{ L"ControllerWindowManager" };
	_logger.info("monarch-controller-ready");
}

/// <summary>
/// Sets timers to request the window handle from the preview window.
/// We use timers to give the preview window enough time to load.
/// </summary>
void ControllerWindowManager::requestPreviewWindowHandle()
{
	SetTimer(_controllerWindow->GetHandle(), IDT_TIMER_REQ_HANDLE_1, 50, (TIMERPROC)NULL);
	SetTimer(_controllerWindow->GetHandle(), IDT_TIMER_REQ_HANDLE_1, 500, (TIMERPROC)NULL);
}

void ControllerWindowManager::_showAndSetUpControllerWindow(WindowInfo controllerWindowInfo)
{
	// @GOTCHA: The Monarch CLI kills the controller window using its title.
	// If you change the title, change the CLI as well.
	if (!_controllerWindow->CreateAndShow(
		to_wstring(_projectName) + L" - Monarch",
		Win32Window::Point(controllerWindowInfo.topLeft.x, controllerWindowInfo.topLeft.y),
		Win32Window::Size(controllerWindowInfo.size.width, controllerWindowInfo.size.height))) {
		throw std::runtime_error{ "Controller window was not created successfully" };
	}
	_controllerWindow->SetQuitOnClose(true);
}


/// PreviewWindowManager

PreviewWindowManager::PreviewWindowManager(
	std::string previewApiBundlePath,
	std::string previewWindowBundlePath,
	std::string defaultLogLevelString,
	std::string cliGrpcServerPort)
{
	_previewApiBundlePath = previewApiBundlePath;
	_previewWindowBundlePath = previewWindowBundlePath;
	_defaultLogLevelString = defaultLogLevelString;
	_cliGrpcServerPort = cliGrpcServerPort;

	_previewApi = nullptr;
	_previewWindow = nullptr;
	_channels = nullptr;

	selectedDockSide = DockSide::right;
}

PreviewWindowManager::~PreviewWindowManager()
{
	auto apiPtr = _previewApi.release();
	delete apiPtr;

	auto windowPtr = _previewWindow.release();
	delete windowPtr;

	auto channelsPtr = _channels.release();
	delete channelsPtr;
}

void PreviewWindowManager::launchWindow()
{
	flutter::DartProject previewApiProject(to_wstring(_previewApiBundlePath));
	flutter::DartProject previewWindowProject(to_wstring(_previewWindowBundlePath));

	std::vector<std::string> apiArguments = { _defaultLogLevelString, _cliGrpcServerPort };
	previewApiProject.set_dart_entrypoint_arguments(apiArguments);
	std::vector<std::string> windowArguments = { _defaultLogLevelString };
	previewWindowProject.set_dart_entrypoint_arguments(windowArguments);

	_previewWindow = std::make_unique<PreviewWindow>(
		previewWindowProject,
		this);
	_showAndSetUpPreviewWindow(ControllerWindow::defaultWindowInfo);

	_previewApi = std::make_unique<PreviewServer>(
		previewApiProject,
		this);
	_previewApi->create();

	_channels = std::make_unique<Channels>(
		_previewApi->engine()->messenger(),
		_previewWindow->messenger(),
		this);
	_channels->setUpCallForwarding();

	Logger _logger{ L"PreviewWindowManager" };
	_logger.info("monarch-preview-ready");
}

/// <summary>
/// Sets timers to request the window handle from the controller window.
/// We use timers to give the controller window enough time to load.
/// </summary>
void PreviewWindowManager::requestControllerWindowHandle()
{
	SetTimer(_previewWindow->GetHandle(), IDT_TIMER_REQ_HANDLE_1, 50, (TIMERPROC)NULL);
	SetTimer(_previewWindow->GetHandle(), IDT_TIMER_REQ_HANDLE_1, 500, (TIMERPROC)NULL);
}

void PreviewWindowManager::_showAndSetUpPreviewWindow(WindowInfo controllerWindowInfo)
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

void PreviewWindowManager::resizePreviewWindow()
{
	auto result_handler = std::make_unique<flutter::MethodResultFunctions<>>(
		[=](const EncodableValue* success_value) {
			auto args = std::get<EncodableMap>(*success_value);
			MonarchState state{ args };
			resizePreviewWindow(state);
		},
		nullptr, nullptr);

	_channels->previewApiChannel->InvokeMethod(
		MonarchMethods::getState, nullptr, std::move(result_handler));
}

void PreviewWindowManager::resizePreviewWindow(MonarchState state)
{
	_postMessageStateChange(state);
}

void PreviewWindowManager::setDocking()
{
	auto result_handler = std::make_unique<flutter::MethodResultFunctions<>>(
		[=](const EncodableValue* success_value) {
			auto args = std::get<EncodableMap>(*success_value);
			MonarchState state{ args };
			setDocking(state);
		},
		nullptr, nullptr);

	_channels->previewApiChannel->InvokeMethod(
		MonarchMethods::getState, nullptr, std::move(result_handler));
}

void PreviewWindowManager::setDocking(MonarchState state)
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

void PreviewWindowManager::restartPreviewWindow()
{
	_channels->sendWillClosePreview();
	_channels->unregisterMethodCallHandlers();

	auto controllerWindowHandle = _previewWindow->getControllerWindowHandle();

	_previewWindow->SetQuitOnClose(false);
	_previewWindow->Destroy();

	flutter::DartProject previewProject(to_wstring(_previewWindowBundlePath));
	std::vector<std::string> previewArguments = { _defaultLogLevelString };
	previewProject.set_dart_entrypoint_arguments(previewArguments);

	_previewWindow = std::make_unique<PreviewWindow>(
		previewProject,
		this);
	
	auto controllerWindowInfo = _previewWindow->getWindowInfo(controllerWindowHandle);
	_showAndSetUpPreviewWindow(controllerWindowInfo);

	PreviewWindow::requestControllerWindowHandle(_previewWindow->GetHandle());
	ControllerWindow::requestPreviewWindowHandle(controllerWindowHandle);


	_channels->restartPreviewChannel(_previewWindow->messenger());
	resizePreviewWindow();
}

void PreviewWindowManager::destroyWindow()
{
	DestroyWindow(_previewWindow->GetHandle());
}

void PreviewWindowManager::_postMessageStateChange(MonarchState state_)
{
	MonarchState* state = new MonarchState(state_);
	PostMessage(_previewWindow->GetHandle(), WM_M_STATECHANGE, LPARAM(state), 0);
}
