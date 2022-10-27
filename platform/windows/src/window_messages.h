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

struct MonarchWindowMessages
{
  static LPCSTR requestControllerHandleString;
  static LPCSTR controllerHandleString;

  static LPCSTR requestPreviewHandleString;
  static LPCSTR previewHandleString;

  static LPCSTR previewMoveString;
  static LPCSTR controllerMoveString;
  
  static UINT previewMoveMessage;
  static UINT controllerMoveMessage;

  static UINT requestControllerHandleMessage;
  static UINT controllerHandleMessage;

  static UINT requestPreviewHandleMessage;
  static UINT previewHandleMessage;
};


// Monarch state changed
#define WM_M_STATECHANGE (WM_USER + 52)

// User selected undock
#define WM_M_UNDOCK (WM_USER + 53)

#define IDT_TIMER_REQ_HANDLE_1 UINT_PTR(1000)
#define IDT_TIMER_REQ_HANDLE_2 UINT_PTR(2000)