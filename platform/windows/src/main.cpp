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

  std::string controllerBundlePath = "";
  std::string projectBundlePath = "";

  std::string controllerBundleKeyArg = "--controller-bundle";
  std::string projectBundleKeyArg = "--project-bundle";
  std::string logLevelKeyArg = "--log-level";

  if (arguments.size() < 6) {
    _logger.severe("Expected arguments: " + controllerBundleKeyArg + " " + projectBundleKeyArg + " " + logLevelKeyArg);
    return EXIT_FAILURE;
  }

  std::string arg0 = trim_copy(arguments[0]);
  std::string arg1 = trim_copy(arguments[1]);
  std::string arg2 = trim_copy(arguments[2]);
  std::string arg3 = trim_copy(arguments[3]);
  std::string arg4 = trim_copy(arguments[4]);
  std::string arg5 = trim_copy(arguments[5]);

  if (controllerBundleKeyArg.compare(arg0) == 0) {
    controllerBundlePath = arg1;
    _logger.config(controllerBundleKeyArg + "=" + controllerBundlePath);
  }
  else {
    _logger.severe(controllerBundleKeyArg + " argument not found");
    return EXIT_FAILURE;
  }

  if (projectBundleKeyArg.compare(arg2) == 0) {
    projectBundlePath = arg3;
    _logger.config(projectBundleKeyArg + "=" + projectBundlePath);
  }
  else {
    _logger.severe(projectBundleKeyArg + " argument not found");
    return EXIT_FAILURE;
  }

  if (logLevelKeyArg.compare(arg4) == 0)
  {
    auto logLevel = arg5;
    defaultLogLevel = logLevelFromString(logLevel);
    _logger.config(logLevelKeyArg + "=" + logLevel);
  }

  auto manager = WindowManager(controllerBundlePath, projectBundlePath);
  manager.launchWindows();

  ::MSG msg;
  while (::GetMessage(&msg, nullptr, 0, 0)) {
    ::TranslateMessage(&msg);
    ::DispatchMessage(&msg);
  }

  ::CoUninitialize();
  return EXIT_SUCCESS;
}

