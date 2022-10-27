#pragma once

#include <string>
#include "../gen/runner/flutter_window.h"
#include "dock_side.h"
#include "monarch_state.h"
#include "monarch_window.h"
#include "channels.h"

class ControllerWindow;
class PreviewWindow;
class PreviewApiRunner;
class Channels;

class ControllerWindowManager
{
public:
	ControllerWindowManager(
		std::string controllerWindowBundlePath,
		std::string defaultLogLevelString,
		std::string cliGrpcServerPort,
		std::string projectName);
	~ControllerWindowManager();

	void launchControllerWindow();
	void requestPreviewWindowHandle();

private:
	std::string _controllerWindowBundlePath;
	std::string _defaultLogLevelString;
	std::string _cliGrpcServerPort;
	std::string _projectName;

	std::unique_ptr<ControllerWindow> _controllerWindow;
	HWND _previewWindowHandle;

	void _showAndSetUpControllerWindow(WindowInfo windowInfo);
};

class PreviewWindowManager
{
public:
	PreviewWindowManager(
		std::string previewServerBundlePath,
		std::string previewWindowBundlePath,
		std::string defaultLogLevelString,
		std::string cliGrpcServerPort);
	~PreviewWindowManager();

	DockSide selectedDockSide;

	void launchPreviewWindow();
	void runPreviewApi();
	void setUpChannels();
	void requestControllerWindowHandle();
	void resizePreviewWindow();
	void resizePreviewWindow(MonarchState state);
	void setDocking();
	void setDocking(MonarchState state);
	void restartPreviewWindow();
	void terminate();

private:
	std::string _previewWindowBundlePath;
	std::string _previewApiBundlePath;
	std::string _defaultLogLevelString;
	std::string _cliGrpcServerPort;

	std::unique_ptr<PreviewWindow> _previewWindow;
	std::unique_ptr<PreviewApiRunner> _previewApi;
	HWND _controllerWindowHandle;

	std::unique_ptr<Channels> _channels;

	void _showAndSetUpPreviewWindow(WindowInfo windowInfo);
	void _postMessageStateChange(MonarchState state);
};