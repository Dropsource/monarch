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
	
	//_controllerWindow->setPreviewWindow(_previewWindow->GetHandle());

	Logger _logger{ L"ControllerWindowManager" };
	_logger.info("monarch-controller-ready");
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


/////


PreviewWindowManager::PreviewWindowManager(
	std::string previewServerBundlePath,
	std::string previewWindowBundlePath,
	std::string defaultLogLevelString,
	std::string cliGrpcServerPort)
{
	_previewServerBundlePath = previewServerBundlePath;
	_previewWindowBundlePath = previewWindowBundlePath;
	_defaultLogLevelString = defaultLogLevelString;
	_cliGrpcServerPort = cliGrpcServerPort;

	_previewServer = nullptr;
	_previewWindow = nullptr;
	_channels = nullptr;

	selectedDockSide = DockSide::right;
}

PreviewWindowManager::~PreviewWindowManager()
{
	auto controllerPtr = _previewServer.release();
	delete controllerPtr;

	auto previewPtr = _previewWindow.release();
	delete previewPtr;

	auto channelsPtr = _channels.release();
	delete channelsPtr;
}

void PreviewWindowManager::launchWindow()
{
	flutter::DartProject serverProject(to_wstring(_previewServerBundlePath));
	flutter::DartProject previewProject(to_wstring(_previewWindowBundlePath));

	std::vector<std::string> controllerArguments = { _defaultLogLevelString, _cliGrpcServerPort };
	serverProject.set_dart_entrypoint_arguments(controllerArguments);
	std::vector<std::string> previewArguments = { _defaultLogLevelString };
	previewProject.set_dart_entrypoint_arguments(previewArguments);

	_previewWindow = std::make_unique<PreviewWindow>(
		previewProject,
		this);
	_showAndSetUpPreviewWindow(ControllerWindow::defaultWindowInfo);

	_previewServer = std::make_unique<PreviewServer>(
		serverProject,
		this);
	_previewServer->create();
	//_showAndSetUpControllerWindow(controllerWindowInfo);

	_channels = std::make_unique<Channels>(
		_previewServer->engine()->messenger(),
		_previewWindow->messenger(),
		this);
	_channels->setUpCallForwarding();


	// @TODO: remove
	//_controllerWindowHandle = FindWindowA(nullptr, "monarch_window_controller");
	//if (_controllerWindowHandle != NULL) {
	//	_previewWindow->setControllerWindow(_controllerWindowHandle);
	//}
	


	//_controllerWindow->setPreviewWindow(_previewWindow->GetHandle());
	//_previewWindow->setControllerWindow(_controllerWindow->GetHandle());

	Logger _logger{ L"PreviewWindowManager" };
	_logger.info("monarch-preview-ready");
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
	/*_channels->sendWillClosePreview();
	_channels->unregisterMethodCallHandlers();

	_previewWindow->SetQuitOnClose(false);
	_previewWindow->Destroy();

	flutter::DartProject previewProject(to_wstring(_previewWindowBundlePath));
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

void PreviewWindowManager::_postMessageStateChange(MonarchState state_)
{
	if (_isControllerWindowSet())
	{
		WindowInfo* windowInfo = new WindowInfo(_getControllerWindowInfo());
		MonarchState* state = new MonarchState(state_);
		PostMessage(_previewWindow->GetHandle(), WM_M_STATECHANGE, WPARAM(windowInfo), LPARAM(state));
	}
}

WindowInfo PreviewWindowManager::_getControllerWindowInfo()
{
	return WindowInfo(
		WindowHelper::getTopLeftPoint(_controllerWindowHandle),
		WindowHelper::getWindowSize(_controllerWindowHandle));
}

bool PreviewWindowManager::_isControllerWindowSet()
{
	return _controllerWindowHandle != nullptr;
}