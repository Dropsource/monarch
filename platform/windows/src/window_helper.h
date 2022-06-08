#pragma once

#include <windows.h>
#include "window_messages.h"

const unsigned int DISTANCE_BETWEEN_WINDOWS = 1;

namespace WindowHelper
{
	// Returns the window size of the given handle.
	// Make sure to pass a handle owned by the calling thread. Avoid passing
	// a handle owned by another thread.
	Size_ getWindowSize(HWND windowHandle);

	// Returns the top left point of the window of the given handle.
	// Make sure to pass a handle owned by the calling thread. Avoid passing
	// a handle owned by another thread.
	Point_ getTopLeftPoint(HWND windowHandle);

	Point_ getRightWindowTopLeft(WindowInfo leftWindowInfo);

	Point_ getLeftWindowTopLeft(WindowInfo leftWindowInfo,
		WindowInfo rightWindowInfo);


	double getDpiScaleFactor(HWND windowHandle);
	int convert(long source, double scale_factor);
	int scale(int source, double scale_factor);
};
