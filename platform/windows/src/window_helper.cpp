#include "window_helper.h"
#include "../gen/runner/flutter_window.h"


Size_ WindowHelper::getWindowSize(HWND windowHandle)
{
    RECT frame;
    GetWindowRect(windowHandle, &frame);
    return Size_(frame.right - frame.left, frame.bottom - frame.top);
}

Point_ WindowHelper::getTopLeftPoint(HWND windowHandle)
{
    RECT frame;
    GetWindowRect(windowHandle, &frame);
    return Point_(frame.left, frame.top);
}

Point_ WindowHelper::getRightWindowTopLeft(WindowInfo leftWindowInfo)
{
    auto leftWindowTopLeft = leftWindowInfo.topLeft;
    auto leftWindowSize = leftWindowInfo.size;

    auto rightWindowTopLeft = Point_(
        leftWindowTopLeft.x + leftWindowSize.width + DISTANCE_BETWEEN_WINDOWS,
        leftWindowTopLeft.y);

    return rightWindowTopLeft;
}

Point_ WindowHelper::getLeftWindowTopLeft(WindowInfo leftWindowInfo, WindowInfo rightWindowInfo)
{
    auto rightWindowTopLeft = rightWindowInfo.topLeft;
    auto leftWindowSize = leftWindowInfo.size;

    auto leftWindowTopLeft = Point_(
        rightWindowTopLeft.x - leftWindowSize.width - DISTANCE_BETWEEN_WINDOWS,
        rightWindowTopLeft.y);

    return leftWindowTopLeft;
}

double WindowHelper::getDpiScaleFactor(HWND windowHandle)
{
    auto dpi = FlutterDesktopGetDpiForHWND(windowHandle);
    double scale_factor = dpi / 96.0;
    return scale_factor;
}

int WindowHelper::convert(long source, double scale_factor)
{
    return static_cast<int>(source / scale_factor);
}

int WindowHelper::scale(int source, double scale_factor)
{
    return static_cast<int>(source * scale_factor);
}
