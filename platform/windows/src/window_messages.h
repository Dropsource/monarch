#pragma once

#include "dock_side.h"

struct Point_ 
{
    unsigned int x;
    unsigned int y;
    Point_(unsigned int x, unsigned int y) : x(x), y(y) {}
};

struct Size_ 
{
    unsigned int width;
    unsigned int height;
    Size_(unsigned int width, unsigned int height)
        : width(width), height(height) {}
};

struct WindowInfo 
{
    Point_ topLeft;
    Size_ size;
    WindowInfo(Point_ topLeft, Size_ size)
        : topLeft(topLeft), size(size) {}
};


// Preview window moved
#define WM_M_PREVMOVE (WM_USER + 50)

// Controller window moved
#define WM_M_CONTMOVE (WM_USER + 51)

// Monarch state changed
#define WM_M_STATECHANGE (WM_USER + 52)

// User selected undock
#define WM_M_UNDOCK (WM_USER + 53)
