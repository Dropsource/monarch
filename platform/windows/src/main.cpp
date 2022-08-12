#include <flutter/dart_project.h>
#include <flutter/flutter_view_controller.h>
#include <windows.h>
#include <stdexcept>

#include "../gen/runner/flutter_window.h"
#include "../gen/runner/utils.h"
#include "window_manager.h"
#include "string_utils.h"
#include "logger.h"

int APIENTRY wWinMain(_In_ HINSTANCE instance, _In_opt_ HINSTANCE prev,
                      _In_ wchar_t *command_line, _In_ int show_command) {
  // Attach to console when present (e.g., 'flutter run') or create a
  // new console when running with a debugger.
  if (!::AttachConsole(ATTACH_PARENT_PROCESS) && ::IsDebuggerPresent()) {
    CreateAndAttachConsole();
  }

  // Initialize COM, so that it is available for use in the library and/or
  // plugins.
  ::CoInitializeEx(nullptr, COINIT_APARTMENTTHREADED);

  Logger _logger{ L"Main" };

  std::vector<std::string> arguments = GetCommandLineArguments();

  if (arguments.size() < 5) {
    _logger.severe("Expected 5 arguments in this order: controller-bundle preview-bundle log-level cli-grpc-server-port project-name");
    return EXIT_FAILURE;
  }

  std::string controllerBundlePath = trim_copy(arguments[0]);
  std::string previewBundlePath = trim_copy(arguments[1]);
  std::string defaultLogLevelString = trim_copy(arguments[2]);
  std::string cliGrpcServerPort = trim_copy(arguments[3]);
  std::string projectName = trim_copy(arguments[4]);

  defaultLogLevel = logLevelFromString(defaultLogLevelString);

  /*_logger.shout("start sleep");
  Sleep(10000);
  _logger.shout("end sleep");*/

  auto manager = WindowManager(
    controllerBundlePath, 
    previewBundlePath,
    defaultLogLevelString,
    cliGrpcServerPort,
    projectName);
  manager.launchWindows();

  ::MSG msg;
  while (::GetMessage(&msg, nullptr, 0, 0)) {
    ::TranslateMessage(&msg);
    ::DispatchMessage(&msg);
  }

  ::CoUninitialize();
  return EXIT_SUCCESS;
}

