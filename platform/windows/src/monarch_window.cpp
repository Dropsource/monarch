#include "monarch_window.h"

#include <windows.h>
#include <stdlib.h>
#include <string.h>
#include <tchar.h>

#include <flutter/dart_project.h>

#include "string_utils.h"
#include "monarch_state.h"

/// MonarchWindow

MonarchWindow::MonarchWindow(
	const flutter::DartProject& project)
	: FlutterWindow(project)
{
}

MonarchWindow::~MonarchWindow()
{
}

void MonarchWindow::setTitle(std::string title)
{
	auto wtitle = to_wstring(title);
	SetWindowText(GetHandle(), &wtitle[0]);
}

WindowInfo MonarchWindow::getWindowInfo()
{
	return getWindowInfo(GetHandle());
}

WindowInfo MonarchWindow::getWindowInfo(HWND handle)
{
	return WindowInfo(
		WindowHelper::getTopLeftPoint(handle),
		WindowHelper::getWindowSize(handle));
}

void MonarchWindow::move(int X, int Y, int nWidth, int nHeight)
{
	isMovingProgrammatically = true;
	MoveWindow(
		GetHandle(),
		X, Y,
		nWidth, nHeight,
		TRUE);
	isMovingProgrammatically = false;
}

flutter::BinaryMessenger* MonarchWindow::messenger()
{
	return flutter_controller_->engine()->messenger();
}



/// ControllerWindow

WindowInfo ControllerWindow::defaultWindowInfo = WindowInfo(Point_(200, 200), Size_(600, 700));

ControllerWindow::ControllerWindow(
	const flutter::DartProject& project)
	: MonarchWindow(project)
{
	_previewWindowHandle = nullptr;
}

ControllerWindow::~ControllerWindow()
{
}

void ControllerWindow::requestPreviewWindowHandle()
{
	requestPreviewWindowHandle(GetHandle());
}

void ControllerWindow::requestPreviewWindowHandle(HWND controllerWindowHandle)
{
	::PostMessage(HWND_BROADCAST, MonarchWindowMessages::requestPreviewHandleMessage, WPARAM(controllerWindowHandle), 0);
}

LRESULT ControllerWindow::MessageHandler(
	HWND hwnd, 
	UINT const message, 
	WPARAM const wparam, 
	LPARAM const lparam) noexcept
{
	switch (message) {
	case WM_TIMER:
		switch (wparam)
		{
		case IDT_TIMER_REQ_HANDLE_1:
			requestPreviewWindowHandle();
			KillTimer(GetHandle(), IDT_TIMER_REQ_HANDLE_1);
			break;

		case IDT_TIMER_REQ_HANDLE_2:
			requestPreviewWindowHandle();
			KillTimer(GetHandle(), IDT_TIMER_REQ_HANDLE_2);
			break;
		}
		break;

	case WM_MOVE:
		if (_isPreviewWindowSet() && !isMovingProgrammatically) {
			_postMoveMessage();
		}
		break;

	case WM_SIZE:
		if (_isPreviewWindowSet()) {
			_postMoveMessage();
		}
		break;

	case WM_GETMINMAXINFO:
		{
			LPMINMAXINFO lpMMI = (LPMINMAXINFO)lparam;
			lpMMI->ptMinTrackSize.x = 575;
			lpMMI->ptMinTrackSize.y = 500;
		}
		break;
	}

	if (message == MonarchWindowMessages::requestControllerHandleMessage)
	{
		// The preview sent a request to get the controller window handle.
		HWND previewHandle = HWND(wparam);
		::PostMessage(previewHandle, MonarchWindowMessages::controllerHandleMessage, WPARAM(GetHandle()), 0);
	}
	else if (message == MonarchWindowMessages::previewHandleMessage)
	{
		// The preview sent its window handle, store it.
		_previewWindowHandle = HWND(wparam);
	}
	else if (message == MonarchWindowMessages::previewMoveMessage)
	{
		HWND previewHandle = HWND(wparam);
		DockSide dockSide = DockSide(lparam);
		auto previewWindowInfo = getWindowInfo(previewHandle);

		auto point = _getTopLeft(previewWindowInfo, dockSide);
		auto size = getWindowInfo().size;

		move(point.x, point.y, size.width, size.height);
	}

	return MonarchWindow::MessageHandler(hwnd, message, wparam, lparam);
}

Point_ ControllerWindow::_getTopLeft(WindowInfo previewWindowInfo, DockSide side)
{
	auto controllerWindowInfo = getWindowInfo();
	switch (side)
	{
	case DockSide::right:
		return WindowHelper::getLeftWindowTopLeft(controllerWindowInfo, previewWindowInfo);
	case DockSide::left:
		return WindowHelper::getRightWindowTopLeft(previewWindowInfo);
	case DockSide::undock:
		return WindowHelper::getTopLeftPoint(GetHandle());
	default:
		throw std::runtime_error{ "DockSide not valid" };
	}
}

bool ControllerWindow::_isPreviewWindowSet()
{
	return _previewWindowHandle != nullptr;
}

void ControllerWindow::_postMoveMessage()
{
	::PostMessage(
		_previewWindowHandle, 
		MonarchWindowMessages::controllerMoveMessage, 
		WPARAM(GetHandle()), 
		0);
}



/// PreviewWindow

PreviewWindow::PreviewWindow(
	const flutter::DartProject& project,
	PreviewWindowManager* windowManager)
	: MonarchWindow(project), windowManager(windowManager)
{
	_controllerWindowHandle = nullptr;
}

PreviewWindow::~PreviewWindow()
{
}

void PreviewWindow::resize(
	Size_ deviceSize, 
	double scale, 
	DockSide dockSide, 
	WindowInfo controllerWindowInfo)
{
	auto deviceWidth = deviceSize.width;
	auto deviceHeight = deviceSize.height;
	auto scaledWidth = WindowHelper::scale((int)deviceWidth, scale);
	auto scaledHeight = WindowHelper::scale((int)deviceHeight, scale);

	Size_ size((long)scaledWidth, (long)scaledHeight);
	resizeDpiAware(size, dockSide, controllerWindowInfo);
	resizeUsingClientRectOffset(size, dockSide, controllerWindowInfo);
	_move(dockSide, controllerWindowInfo);
}

void PreviewWindow::undock()
{
	unsigned int offset = 24;
	auto point = WindowHelper::getTopLeftPoint(GetHandle());
	auto size = WindowHelper::getWindowSize(GetHandle());

	move(
		point.x + offset, 
		point.y + offset,
		size.width, 
		size.height);
}

void PreviewWindow::resizeDpiAware(
	const Size_ size, 
	DockSide dockSide, 
	WindowInfo controllerWindowInfo)
{
	auto target_point = _getTopLeft(controllerWindowInfo, dockSide);
	double scale_factor = WindowHelper::getDpiScaleFactor(GetHandle());

	move(
		target_point.x, 
		target_point.y,
		WindowHelper::scale(size.width, scale_factor), 
		WindowHelper::scale(size.height, scale_factor));
}

void PreviewWindow::resizeUsingClientRectOffset(
	const Size_ size, 
	DockSide dockSide, 
	WindowInfo controllerWindowInfo)
{
	RECT clientFrame;
	GetClientRect(GetHandle(), &clientFrame);

	double scale_factor = WindowHelper::getDpiScaleFactor(GetHandle());

	clientFrame.right = WindowHelper::convert(clientFrame.right, scale_factor);
	clientFrame.bottom = WindowHelper::convert(clientFrame.bottom, scale_factor);

	//Logger _logger{ L"PreviewWindow::resizeUsingClientRectOffset" };
	//_logger.shout(L"size: " + std::to_wstring(size.width) + L"x" + std::to_wstring(size.height));
	//_logger.shout(L"client: " + std::to_wstring(clientFrame.right) + L"x" + std::to_wstring(clientFrame.bottom));

	//auto offset = size.width - (int)clientFrame.right;
	Size_ offset(
		size.width - (int)clientFrame.right,
		size.height - (int)clientFrame.bottom);
	Size_ sizePlusOffset(
		size.width + offset.width,
		size.height + offset.height);

	resizeDpiAware(sizePlusOffset, dockSide, controllerWindowInfo);
}

void PreviewWindow::disableResizeMinimize()
{
	SetWindowLong(
		GetHandle(),
		GWL_STYLE,
		GetWindowLong(GetHandle(), GWL_STYLE) & ~WS_SIZEBOX & ~WS_MAXIMIZEBOX);
}

HWND PreviewWindow::getControllerWindowHandle()
{
	return _controllerWindowHandle;
}

void PreviewWindow::requestControllerWindowHandle()
{
	requestControllerWindowHandle(GetHandle());
}

void PreviewWindow::requestControllerWindowHandle(HWND previewWindowHandle)
{
	::PostMessage(HWND_BROADCAST, MonarchWindowMessages::requestControllerHandleMessage, WPARAM(previewWindowHandle), 0);
}

LRESULT PreviewWindow::MessageHandler(
	HWND hwnd,
	UINT const message, 
	WPARAM const wparam, 
	LPARAM const lparam) noexcept
{
	switch (message) {
	case WM_TIMER:
		switch (wparam)
		{
		case IDT_TIMER_REQ_HANDLE_1:
			requestControllerWindowHandle();
			KillTimer(GetHandle(), IDT_TIMER_REQ_HANDLE_1);
			break;

		case IDT_TIMER_REQ_HANDLE_2:
			requestControllerWindowHandle();
			KillTimer(GetHandle(), IDT_TIMER_REQ_HANDLE_2);
			break;
		}
		break;

	case WM_M_STATECHANGE:
	{		
		MonarchState* state = (MonarchState*)wparam;
		
		Size_ deviceSize(
			(int)state->device.logicalResolution.width,
			(int)state->device.logicalResolution.height);

		if (isControllerWindowSet())
		{
			auto controllerWindowInfo = getWindowInfo(_controllerWindowHandle);
			resize(deviceSize, state->scale.scale, state->dock, controllerWindowInfo);
		}

		auto title = state->scale.scale == defaultStoryScaleDefinition.scale ?
			state->device.title() :
			state->device.title() + " | " + state->scale.name;
		setTitle(title);

		delete state;
	}
	break;

	case WM_M_UNDOCK:
		undock();
		break;

	case WM_MOVE:
		if (!isMovingProgrammatically && isControllerWindowSet()) {
			PostMessage(
				_controllerWindowHandle,
				MonarchWindowMessages::previewMoveMessage,
				WPARAM(GetHandle()), 
				LPARAM(windowManager->selectedDockSide));
		}
		break;
	}

	if (message == MonarchWindowMessages::requestPreviewHandleMessage)
	{
		// The controller sent a request to get the preview window handle.
		HWND controllerHandle = HWND(wparam);
		::PostMessage(controllerHandle, MonarchWindowMessages::previewHandleMessage, WPARAM(GetHandle()), 0);
	}
	else if (message == MonarchWindowMessages::controllerHandleMessage)
	{
		// The controller sent its window handle, store it.
		_controllerWindowHandle = HWND(wparam);
		windowManager->controllerWindowHandle = HWND(wparam);
	}
	else if (message == MonarchWindowMessages::controllerMoveMessage)
	{
		HWND controllerHandle = HWND(wparam);
		DockSide dockSide = windowManager->selectedDockSide;
		auto controllerWindowInfo = getWindowInfo(controllerHandle);

		auto point = _getTopLeft(controllerWindowInfo, dockSide);
		auto size = getWindowInfo().size;

		move(point.x, point.y, size.width, size.height);
	}

	return MonarchWindow::MessageHandler(hwnd, message, wparam, lparam);
}

void PreviewWindow::_move(DockSide side, WindowInfo controllerWindowInfo)
{
	auto point = _getTopLeft(controllerWindowInfo, side);
	auto size = getWindowInfo().size;

	move(
		point.x, 
		point.y,
		size.width, 
		size.height);
}

Point_ PreviewWindow::_getTopLeft(WindowInfo controllerWindowInfo, DockSide side)
{
	auto previewWindowInfo = getWindowInfo();
	switch (side)
	{
	case DockSide::right:
		return WindowHelper::getRightWindowTopLeft(controllerWindowInfo);
	case DockSide::left:
		return WindowHelper::getLeftWindowTopLeft(previewWindowInfo, controllerWindowInfo);
	case DockSide::undock:
		return WindowHelper::getTopLeftPoint(GetHandle());
	default:
		throw std::runtime_error{ "DockSide not valid" };
	}
}

bool PreviewWindow::isControllerWindowSet()
{
	return _controllerWindowHandle != nullptr;
}


/// PreviewApiRunner

PreviewApiRunner::PreviewApiRunner(const flutter::DartProject& project)
	: project_(project)
{
}

PreviewApiRunner::~PreviewApiRunner()
{
	auto ptr = engine_.release();
	delete ptr;
}

void PreviewApiRunner::run()
{
	engine_ = std::make_unique<flutter::FlutterEngine>(project_);
	engine_->Run("");
}

flutter::BinaryMessenger* PreviewApiRunner::messenger()
{
	return engine_->messenger();
}

void PreviewApiRunner::shutDown()
{
	engine_->ShutDown();
}