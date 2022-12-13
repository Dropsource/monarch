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

UINT _registerWindowMessage(LPCSTR message, std::string identifier)
{
  std::string messageString(message);
  messageString += identifier;
  return RegisterWindowMessageA(messageString.c_str());
}

/// <summary>
/// On Windows, at runtime, we execute two instances of the monarch_windows executable,
/// one instance in preview mode and another one in controller mode.
/// 
/// Since these two instances are separate processes, we use window messages so they 
/// can talk to each other. (See RegisterWindowMessageA winapi function).
/// 
/// If the user runs monarch on multiple projects, there could be multiple preview windows
/// and multiple controller windows, which could lead to conflicts between their window
/// messages.
/// 
/// To avoid this conflict, each pair of preview window and controller window 
/// registers its window messages using an identifier which uniquely identifies each 
/// monarch run.
/// 
/// As of 2022-10-20, we are passing the cli-grpc-server-port as the identifier. The cli 
/// server port is the different on each monarch run thus we can use it as the identifier.
/// </summary>
void _registerWindowMessages(std::string identifier)
{
  MonarchWindowMessages::requestControllerHandleMessage = _registerWindowMessage(MonarchWindowMessages::requestControllerHandleString, identifier);
  MonarchWindowMessages::controllerHandleMessage = _registerWindowMessage(MonarchWindowMessages::controllerHandleString, identifier);
  MonarchWindowMessages::requestPreviewHandleMessage = _registerWindowMessage(MonarchWindowMessages::requestPreviewHandleString, identifier);
  MonarchWindowMessages::previewHandleMessage = _registerWindowMessage(MonarchWindowMessages::previewHandleString, identifier);
  MonarchWindowMessages::previewMoveMessage = _registerWindowMessage(MonarchWindowMessages::previewMoveString, identifier);
  MonarchWindowMessages::controllerMoveMessage = _registerWindowMessage(MonarchWindowMessages::controllerMoveString, identifier);
}

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

  Logger _logger{ L"Main" };

  // _logger.shout("start sleep");
  // Sleep(20000);
  // _logger.shout("end sleep");

  std::vector<std::string> arguments = GetCommandLineArguments();

  if (arguments.size() == 0) {
    std::wcout << L"Missing arguments" << std::endl;
    return EXIT_FAILURE;
  }

  std::string mode = trim_copy(arguments[0]);

  if (mode == "preview") {
    std::string previewApiBundlePath = trim_copy(arguments[1]);
    std::string previewWindowBundlePath = trim_copy(arguments[2]);
    std::string defaultLogLevelString = trim_copy(arguments[3]);
    std::string cliGrpcServerPort = trim_copy(arguments[4]);

    defaultLogLevel = logLevelFromString(defaultLogLevelString);

    _registerWindowMessages(cliGrpcServerPort);

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

    _registerWindowMessages(cliGrpcServerPort);

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