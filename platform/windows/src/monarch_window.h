#pragma once

#include <string>
#include "../gen/runner/flutter_window.h"
#include "window_helper.h"
#include "dock_side.h"
#include "window_manager.h"

class PreviewWindowManager;

class MonarchWindow : public FlutterWindow
{
public:
	MonarchWindow(
		const flutter::DartProject& project);

	virtual ~MonarchWindow();

	void setTitle(std::string title);

	WindowInfo getWindowInfo();
	WindowInfo getWindowInfo(HWND handle);
	void move(int X, int Y, int nWidth, int nHeight);
	flutter::BinaryMessenger* messenger();

protected:
	bool isMovingProgrammatically = false;
};

class ControllerWindow : public MonarchWindow
{
public:
	ControllerWindow(
		const flutter::DartProject& project);

	virtual ~ControllerWindow();

	static WindowInfo defaultWindowInfo;

	void requestPreviewWindowHandle();
	static void requestPreviewWindowHandle(HWND controllerWindowHandle);

protected:
	LRESULT MessageHandler(HWND hwnd, UINT const message, WPARAM const wparam,
		LPARAM const lparam) noexcept override;

private:
	HWND _previewWindowHandle;
	Point_ _getTopLeft(WindowInfo previewWindowInfo, DockSide side);
	bool _isPreviewWindowSet();
	void _postMoveMessage();
};

class PreviewWindow : public MonarchWindow
{
public:
	PreviewWindow(
		const flutter::DartProject& project,
		PreviewWindowManager* windowManager);

	virtual ~PreviewWindow();

	// Resizes this window using the given device dimensions, the scale
	// and the monitor's DPI scale factor.
	// After the window is resized, it resizes it again to make sure the client
	// rect is the same size as the given device dimensions.
	void resize(Size_ deviceSize, double scale, DockSide dockSide,
		WindowInfo controllerWindowInfo);

	void undock();

	// Scales the given size using the DPI scale of this window's
	// monitor. Then resizes this window using the scaled size.
	void resizeDpiAware(const Size_ size, DockSide dockSide,
		WindowInfo controllerWindowInfo);

	// Gets the physical size of the client area rect, which is in physical pixels.
	// It converts the client area rect size into logical pixels (using the 
	// monitor's DPI scale factor). It then computes the offset between the expected
	// client rect size and the actual client rect size. Lastly, it resizes the 
	// window by that offset to make sure the client rect has the given size.
	//
	// The Windows API only lets you set the window size by its outer boundaries.
	// This function allows us to set the window size using its inner client rect.
	void resizeUsingClientRectOffset(const Size_ size, DockSide dockSide,
		WindowInfo controllerWindowInfo);

	void disableResizeMinimize();
	HWND getControllerWindowHandle();
	bool isControllerWindowSet();

	static void requestControllerWindowHandle(HWND previewWindowHandle);
	void requestControllerWindowHandle();

protected:
	LRESULT MessageHandler(HWND window, UINT const message, WPARAM const wparam,
		LPARAM const lparam) noexcept override;

private:
	PreviewWindowManager* windowManager;
	HWND _controllerWindowHandle;
	
	void _move(DockSide side, WindowInfo controllerWindowInfo);
	Point_ _getTopLeft(WindowInfo controllerWindowInfo, DockSide side);
};


class PreviewServer
{
public:
	PreviewServer(
		const flutter::DartProject& project,
		PreviewWindowManager* windowManager);

	virtual ~PreviewServer();

	void create();

	flutter::FlutterEngine* engine() { return engine_.get(); }

private:
	flutter::DartProject project_;
	std::unique_ptr<flutter::FlutterEngine> engine_;
	PreviewWindowManager* windowManager;
};
