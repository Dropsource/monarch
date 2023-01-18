#include "monarch_application.h"

#include <flutter_linux/flutter_linux.h>

struct _MonarchApplication {
  GtkApplication parent_instance;
  char** command_line_arguments;
};

G_DEFINE_TYPE(MonarchApplication, monarch_application, GTK_TYPE_APPLICATION)

static char* get_preview_api_bundle_path(MonarchApplication* application) {
  return application->command_line_arguments[0];
}
static char* get_preview_window_bundle_path(MonarchApplication* application) {
  return application->command_line_arguments[1];
}
static char* get_controller_bundle_path(MonarchApplication* application) {
  return application->command_line_arguments[2];
}
static char* get_default_log_level(MonarchApplication* application) {
  return application->command_line_arguments[3];
}
static char* get_cli_grpc_server_port(MonarchApplication* application) {
  return application->command_line_arguments[4];
}
static char* get_project_name(MonarchApplication* application) {
  return application->command_line_arguments[5];
}

static FlDartProject* init_dart_project(gchar* bundle_path) {
  g_message("init project: %s", bundle_path);

  // g_autoptr(FlDartProject) project = fl_dart_project_new();
  FlDartProject* project = fl_dart_project_new();

  g_autofree gchar* assets_path = g_strconcat(bundle_path, "/", "flutter_assets", NULL);
  g_autofree gchar* icu_path = g_strconcat(bundle_path, "/", "icudtl.dat", NULL);

  fl_dart_project_set_assets_path(project, assets_path);
  fl_dart_project_set_icu_data_path(project, icu_path);

  // g_free(assets_path);
  // g_free(icu_path);
  return project;
}

static void set_preview_api_args(MonarchApplication* self, FlDartProject* project) {
  GPtrArray* args_array = g_ptr_array_new();
  g_ptr_array_add(args_array, const_cast<char*>(get_default_log_level(self)));
  g_ptr_array_add(args_array, const_cast<char*>(get_cli_grpc_server_port(self)));
  g_ptr_array_add(args_array, nullptr);
  gchar** args = reinterpret_cast<gchar**>(g_ptr_array_free(args_array, false));

  fl_dart_project_set_dart_entrypoint_arguments(project, args);
}

static void set_preview_args(MonarchApplication* self, FlDartProject* project) {
  GPtrArray* args_array = g_ptr_array_new();
  g_ptr_array_add(args_array, const_cast<char*>(get_default_log_level(self)));
  g_ptr_array_add(args_array, nullptr);
  gchar** args = reinterpret_cast<gchar**>(g_ptr_array_free(args_array, false));

  fl_dart_project_set_dart_entrypoint_arguments(project, args);
}

static void set_controller_args(MonarchApplication* self, FlDartProject* project) {
  GPtrArray* args_array = g_ptr_array_new();
  g_ptr_array_add(args_array, const_cast<char*>(get_default_log_level(self)));
  g_ptr_array_add(args_array, const_cast<char*>(get_cli_grpc_server_port(self)));
  g_ptr_array_add(args_array, nullptr);
  gchar** args = reinterpret_cast<gchar**>(g_ptr_array_free(args_array, false));

  fl_dart_project_set_dart_entrypoint_arguments(project, args);
}

// Cannot run headless engine on Linux. As a workaround, we'll launch a window which
// will host the flutter engine for the preview api.
// See https://github.com/flutter/flutter/issues/118716
static GtkWindow* init_preview_api_window(GApplication* application) {
  GtkWindow* window =
      GTK_WINDOW(gtk_application_window_new(GTK_APPLICATION(application)));

  GtkHeaderBar* header_bar = GTK_HEADER_BAR(gtk_header_bar_new());
  gtk_widget_show(GTK_WIDGET(header_bar));
  gtk_header_bar_set_title(header_bar, "Preview API Workaround");
  gtk_header_bar_set_show_close_button(header_bar, TRUE);
  gtk_window_set_titlebar(window, GTK_WIDGET(header_bar));

  gtk_window_set_default_size(window, 350, 0);
  gtk_widget_show(GTK_WIDGET(window));
  return window;
}

static GtkWindow* init_preview_window(GApplication* application) {
  GtkWindow* window =
      GTK_WINDOW(gtk_application_window_new(GTK_APPLICATION(application)));

  GtkHeaderBar* header_bar = GTK_HEADER_BAR(gtk_header_bar_new());
  gtk_widget_show(GTK_WIDGET(header_bar));
  gtk_header_bar_set_title(header_bar, "Monarch Preview");
  gtk_header_bar_set_show_close_button(header_bar, TRUE);
  gtk_window_set_titlebar(window, GTK_WIDGET(header_bar));

  gtk_window_set_default_size(window, 390, 844);
  gtk_widget_show(GTK_WIDGET(window));
  return window;
}

static GtkWindow* init_controller_window(GApplication* application, MonarchApplication* self) {
  GtkWindow* window =
      GTK_WINDOW(gtk_application_window_new(GTK_APPLICATION(application)));

  GtkHeaderBar* header_bar = GTK_HEADER_BAR(gtk_header_bar_new());
  gtk_widget_show(GTK_WIDGET(header_bar));
  auto title = g_strconcat(get_project_name(self), " - Monarch", NULL);
  gtk_header_bar_set_title(header_bar, title);
  gtk_header_bar_set_show_close_button(header_bar, TRUE);
  gtk_window_set_titlebar(window, GTK_WIDGET(header_bar));

  gtk_window_set_default_size(window, 700, 830);
  gtk_widget_show(GTK_WIDGET(window));

  g_free(title);
  return window;
}

static void show_window(GtkWindow* window, FlView* view) {
  gtk_widget_show(GTK_WIDGET(window));
  gtk_widget_show(GTK_WIDGET(view));
  gtk_container_add(GTK_CONTAINER(window), GTK_WIDGET(view));
}

// Implements GApplication::activate.
static void monarch_application_activate(GApplication* application) {
  MonarchApplication* self = MONARCH_APPLICATION(application);

  g_autoptr(FlDartProject) preview_api_project = init_dart_project(get_preview_api_bundle_path(self));
  g_autoptr(FlDartProject) preview_project = init_dart_project(get_preview_window_bundle_path(self));
  g_autoptr(FlDartProject) controller_project = init_dart_project(get_controller_bundle_path(self));

  set_preview_api_args(self, preview_api_project);
  set_preview_args(self, preview_project);
  set_controller_args(self, controller_project);

  auto preview_api_view = fl_view_new(preview_api_project);
  auto preview_view = fl_view_new(preview_project);
  auto controller_view = fl_view_new(controller_project);

  auto preview_api_window = init_preview_api_window(application);
  auto preview_window = init_preview_window(application);
  auto controller_window = init_controller_window(application, self);

  show_window(preview_api_window, preview_api_view);
  show_window(preview_window, preview_view);
  show_window(controller_window, controller_view);
}

// Implements GApplication::local_command_line.
static gboolean monarch_application_local_command_line(GApplication* application, gchar*** arguments, int* exit_status) {
  MonarchApplication* self = MONARCH_APPLICATION(application);

   if (g_strv_length(*arguments) < 7) {
    g_warning("Expected 7 arguments in this order: executable-path preview-api-bundle preview-window-bundle controller-bundle log-level cli-grpc-server-port project-name");
    *exit_status = 1;
     return TRUE;
  }

  // Strip out the first argument as it is the binary name.
  self->command_line_arguments = g_strdupv(*arguments + 1);

  g_autoptr(GError) error = nullptr;
  if (!g_application_register(application, nullptr, &error)) {
     g_warning("Failed to register: %s", error->message);
     *exit_status = 1;
     return TRUE;
  }

  g_application_activate(application);
  *exit_status = 0;

  return TRUE;
}

// Implements GObject::dispose.
static void monarch_application_dispose(GObject* object) {
  MonarchApplication* self = MONARCH_APPLICATION(object);
  g_clear_pointer(&self->command_line_arguments, g_strfreev);
  G_OBJECT_CLASS(monarch_application_parent_class)->dispose(object);
}

static void monarch_application_class_init(MonarchApplicationClass* klass) {
  G_APPLICATION_CLASS(klass)->activate = monarch_application_activate;
  G_APPLICATION_CLASS(klass)->local_command_line = monarch_application_local_command_line;
  G_OBJECT_CLASS(klass)->dispose = monarch_application_dispose;
}

static void monarch_application_init(MonarchApplication* self) {}

MonarchApplication* monarch_application_new()
{
    return MONARCH_APPLICATION(g_object_new(monarch_application_get_type(),
                                            "application-id", APPLICATION_ID,
                                            "flags", G_APPLICATION_NON_UNIQUE,
                                            nullptr));
}