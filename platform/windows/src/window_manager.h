#pragma once

#include <string>
#include "../gen/runner/flutter_window.h"
#include "dock_side.h"
#include "monarch_state.h"
#include "monarch_window.h"

class ControllerWindow;
class PreviewWindow;

class WindowManager
{
public:
	WindowManager(std::string controllerBundlePath, std::string previewBundlePath);
	~WindowManager();

	DockSide selectedDockSide;

	void launchWindows();
	void resizePreviewWindow(MonarchState state);
	void setDocking(MonarchState state);

private:
	std::string _previewBundlePath;
	std::string _controllerBundlePath;

	std::unique_ptr<ControllerWindow> _controllerWindow;
	std::unique_ptr<PreviewWindow> _previewWindow;

	void _postMesssageStateChange(MonarchState state);
};
