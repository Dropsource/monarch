#include <flutter/dart_project.h>
#include <flutter/flutter_view_controller.h>
#include <windows.h>
#include <stdexcept>

#include "../gen/runner/flutter_window.h"
#include "../gen/runner/utils.h"
#include "window_manager.h"
#include "window_messages.h"
#include "string_utils.h"
#include "logger.h"

LPCSTR MonarchWindowMessages::requestControllerHandleString = "monarch.request.controller.window.handle";
LPCSTR MonarchWindowMessages::controllerHandleString = "monarch.controller.window.handle";

LPCSTR MonarchWindowMessages::requestPreviewHandleString = "monarch.request.preview.window.handle";
LPCSTR MonarchWindowMessages::previewHandleString = "monarch.preview.window.handle";

LPCSTR MonarchWindowMessages::previewMoveString = "monarch.preview.window.move";
LPCSTR MonarchWindowMessages::controllerMoveString = "monarch.controller.window.move";

UINT MonarchWindowMessages::requestControllerHandleMessage = 0;
UINT MonarchWindowMessages::controllerHandleMessage = 0;
UINT MonarchWindowMessages::requestPreviewHandleMessage = 0;
UINT MonarchWindowMessages::previewHandleMessage = 0;
UINT MonarchWindowMessages::previewMoveMessage = 0;
UINT MonarchWindowMessages::controllerMoveMessage = 0;


int APIENTRY wWinMain(_In_ HINSTANCE instance, _In_opt_ HINSTANCE prev,
  _In_ wchar_t* command_line, _In_ int show_command)
{
  // Attach to console when present (e.g., 'flutter run') or create a
  // new console when running with a debugger.
  if (!::AttachConsole(ATTACH_PARENT_PROCESS) && ::IsDebuggerPresent()) {
    CreateAndAttachConsole();
  }

  // Initialize COM, so that it is available for use in the library and/or
  // plugins.
  ::CoInitializeEx(nullptr, COINIT_APARTMENTTHREADED);


  //_logger.shout("start sleep");
  //Sleep(10000);
  //_logger.shout("end sleep");


  Logger _logger{ L"Main" };

  std::vector<std::string> arguments = GetCommandLineArguments();

  if (arguments.size() == 0) {
    std::wcout << L"Missing arguments" << std::endl;
    return EXIT_FAILURE;
  }

  MonarchWindowMessages::requestControllerHandleMessage = RegisterWindowMessageA(MonarchWindowMessages::requestControllerHandleString);
  MonarchWindowMessages::controllerHandleMessage = RegisterWindowMessageA(MonarchWindowMessages::controllerHandleString);
  MonarchWindowMessages::requestPreviewHandleMessage = RegisterWindowMessageA(MonarchWindowMessages::requestPreviewHandleString);
  MonarchWindowMessages::previewHandleMessage = RegisterWindowMessageA(MonarchWindowMessages::previewHandleString);
  MonarchWindowMessages::previewMoveMessage = RegisterWindowMessageA(MonarchWindowMessages::previewMoveString);
  MonarchWindowMessages::controllerMoveMessage = RegisterWindowMessageA(MonarchWindowMessages::controllerMoveString);

  std::string mode = trim_copy(arguments[0]);

  if (mode == "preview") {
    std::string previewApiBundlePath = trim_copy(arguments[1]);
    std::string previewWindowBundlePath = trim_copy(arguments[2]);
    std::string defaultLogLevelString = trim_copy(arguments[3]);
    std::string cliGrpcServerPort = trim_copy(arguments[4]);

    defaultLogLevel = logLevelFromString(defaultLogLevelString);

    auto manager = PreviewWindowManager(
      previewApiBundlePath,
      previewWindowBundlePath,
      defaultLogLevelString,
      cliGrpcServerPort);
    manager.launchPreviewWindow();
    manager.runPreviewApi();
    manager.setUpChannels();
    manager.requestControllerWindowHandle();

    ::MSG msg;
    while (::GetMessage(&msg, nullptr, 0, 0)) {
      ::TranslateMessage(&msg);
      ::DispatchMessage(&msg);
    }

    ::CoUninitialize();
    return EXIT_SUCCESS;
  }
  else if (mode == "controller") {
    std::string controllerBundlePath = trim_copy(arguments[1]);
    std::string defaultLogLevelString = trim_copy(arguments[2]);
    std::string cliGrpcServerPort = trim_copy(arguments[3]);
    std::string projectName = trim_copy(arguments[4]);

    defaultLogLevel = logLevelFromString(defaultLogLevelString);

    auto manager = ControllerWindowManager(
      controllerBundlePath,
      defaultLogLevelString,
      cliGrpcServerPort,
      projectName);
    manager.launchControllerWindow();
    manager.requestPreviewWindowHandle();

    ::MSG msg;
    while (::GetMessage(&msg, nullptr, 0, 0)) {
      ::TranslateMessage(&msg);
      ::DispatchMessage(&msg);
    }

    ::CoUninitialize();
    return EXIT_SUCCESS;
  }
  else {
    std::wcout << L"Unexpected mode, first argument should be `controller` or `preview`" << std::endl;
    return EXIT_FAILURE;
  }
}