#pragma once

#include <string>
#include "../gen/runner/flutter_window.h"
#include "dock_side.h"
#include "monarch_state.h"
#include "monarch_window.h"
#include "channels.h"

class ControllerWindow;
class PreviewWindow;
class HeadlessController;
class Channels;
//
//class WindowManager
//{
//public:
//	WindowManager(
//		std::string controllerBundlePath, 
//		std::string previewBundlePath,
//		std::string defaultLogLevelString,
//		std::string cliGrpcServerPort,
//		std::string projectName);
//	~WindowManager();
//
//	DockSide selectedDockSide;
//
//	void launchWindows();
//	void resizePreviewWindow();
//	void resizePreviewWindow(MonarchState state);
//	void setDocking();
//	void setDocking(MonarchState state);
//	void restartPreviewWindow();
//
//private:
//	std::string _previewBundlePath;
//	std::string _controllerBundlePath;
//	std::string _defaultLogLevelString;
//	std::string _cliGrpcServerPort;
//	std::string _projectName;
//
//	std::unique_ptr<ControllerWindow> _controllerWindow;
//	std::unique_ptr<PreviewWindow> _previewWindow;
//
//	std::unique_ptr<Channels> _channels;
//
//	void _showAndSetUpPreviewWindow(WindowInfo windowInfo);
//	void _showAndSetUpControllerWindow(WindowInfo windowInfo);
//	void _postMessageStateChange(MonarchState state);
//};

class HeadlessWindowManager
{
public:
	HeadlessWindowManager(
		std::string controllerBundlePath,
		std::string previewBundlePath,
		std::string defaultLogLevelString,
		std::string cliGrpcServerPort,
		std::string projectName);
	~HeadlessWindowManager();

	DockSide selectedDockSide;

	void launchWindows();
	void resizePreviewWindow();
	void resizePreviewWindow(MonarchState state);
	void setDocking();
	void setDocking(MonarchState state);
	void restartPreviewWindow();

private:
	std::string _previewBundlePath;
	std::string _controllerBundlePath;
	std::string _defaultLogLevelString;
	std::string _cliGrpcServerPort;
	std::string _projectName;

	std::unique_ptr<PreviewWindow> _previewWindow;
	std::unique_ptr<HeadlessController> _headlessController;

	std::unique_ptr<Channels> _channels;

	void _showAndSetUpPreviewWindow(WindowInfo windowInfo);
	//void _showAndSetUpController(WindowInfo windowInfo);
	void _postMessageStateChange(MonarchState state);
};