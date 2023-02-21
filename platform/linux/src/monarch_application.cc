#include "monarch_application.h"

#include <flutter_linux/flutter_linux.h>

#include "channels.h"
#include "monarch_state.h"

struct _MonarchApplication {
  GtkApplication parent_instance;
  char** command_line_arguments;

  FlView* preview_api_view;
  FlView* preview_view;
  FlView* controller_view;

  GtkWindow* preview_window;
  GtkWindow* preview_api_window;
  GtkWindow* controller_window;

  MonarchChannels* channels;
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
  // g_message("init project: %s", bundle_path);

  FlDartProject* project = fl_dart_project_new();

  g_autofree gchar* assets_path =
      g_strconcat(bundle_path, "/", "flutter_assets", NULL);
  g_autofree gchar* icu_path =
      g_strconcat(bundle_path, "/", "icudtl.dat", NULL);

  fl_dart_project_set_assets_path(project, assets_path);
  fl_dart_project_set_icu_data_path(project, icu_path);

  return project;
}

static void set_preview_api_args(MonarchApplication* self,
                                 FlDartProject* project) {
  GPtrArray* args_array = g_ptr_array_new();
  g_ptr_array_add(args_array, const_cast<char*>(get_default_log_level(self)));
  g_ptr_array_add(args_array,
                  const_cast<char*>(get_cli_grpc_server_port(self)));
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

static void set_controller_args(MonarchApplication* self,
                                FlDartProject* project) {
  GPtrArray* args_array = g_ptr_array_new();
  g_ptr_array_add(args_array, const_cast<char*>(get_default_log_level(self)));
  g_ptr_array_add(args_array,
                  const_cast<char*>(get_cli_grpc_server_port(self)));
  g_ptr_array_add(args_array, nullptr);
  gchar** args = reinterpret_cast<gchar**>(g_ptr_array_free(args_array, false));

  fl_dart_project_set_dart_entrypoint_arguments(project, args);
}

// Cannot run headless engine on Linux. As a workaround, we'll launch a window
// which will host the flutter engine for the preview api. See
// https://github.com/flutter/flutter/issues/118716
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

  // @GOTCHA: (fertrig)
  // Ideally resizable should be false `gtk_window_set_resizable(window,
  // false);` and all the resizing of the preview window should be done
  // programmatically in `resize_preview_window`. However, setting resizable to
  // false prevents the window's width to resize as expected. When resizable is
  // false, smaller devices with smaller scales do not resize the window's
  // width. There seems to be a minimum width that it is only respected when
  // resizable is set to false.
  //
  // I tried a combination of gtk_window_set_default_size,
  // gtk_widget_set_size_request and gtk_window_set_resizable with no luck.
  //
  // If you are trying to make the preview window not resizable by the user,
  // then make sure to test smaller scales with smaller devices to make sure
  // the window is resizing as expected.
  gtk_window_set_resizable(window, true);

  gtk_window_set_default_size(window, 390, 844);
  gtk_widget_show(GTK_WIDGET(window));
  return window;
}

static GtkWindow* init_controller_window(GApplication* application,
                                         MonarchApplication* self) {
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

static void resize_preview_window(MonarchApplication* self,
                                  MonarchDevice* device,
                                  MonarchStoryScale* scale) {
  MonarchLogicalResolution* logical_resolution =
      monarch_device_get_logical_resolution(device);

  double scale_value = monarch_story_scale_get_scale(scale);
  double scaled_width =
      monarch_logical_resolution_get_width(logical_resolution) * scale_value;
  double scaled_height =
      monarch_logical_resolution_get_height(logical_resolution) * scale_value;

  gtk_window_resize(self->preview_window, scaled_width, scaled_height);
}

static void set_preview_window_title(MonarchApplication* self,
                                     MonarchDevice* device,
                                     MonarchStoryScale* scale) {
  if (monarch_story_scale_get_scale(monarch_story_scale_get_default()) ==
      monarch_story_scale_get_scale(scale)) {
    gtk_window_set_title(self->preview_window,
                         monarch_device_get_title(device));

  } else {
    gtk_window_set_title(
        self->preview_window,
        g_strconcat(monarch_device_get_title(device), " | ",
                    monarch_story_scale_get_name(scale), NULL));
  }
}

// Implements GApplication::activate.
static void monarch_application_activate(GApplication* application) {
  MonarchApplication* self = MONARCH_APPLICATION(application);

  g_autoptr(FlDartProject) preview_api_project =
      init_dart_project(get_preview_api_bundle_path(self));
  g_autoptr(FlDartProject) preview_project =
      init_dart_project(get_preview_window_bundle_path(self));
  g_autoptr(FlDartProject) controller_project =
      init_dart_project(get_controller_bundle_path(self));

  set_preview_api_args(self, preview_api_project);
  set_preview_args(self, preview_project);
  set_controller_args(self, controller_project);

  self->preview_api_view = fl_view_new(preview_api_project);
  self->preview_view = fl_view_new(preview_project);
  self->controller_view = fl_view_new(controller_project);

  self->preview_api_window = init_preview_api_window(application);
  self->preview_window = init_preview_window(application);
  self->controller_window = init_controller_window(application, self);

  resize_preview_window(self, monarch_device_get_default_device(),
                        monarch_story_scale_get_default());
  set_preview_window_title(self, monarch_device_get_default_device(),
                           monarch_story_scale_get_default());

  self->channels = monarch_channels_new(
      fl_engine_get_binary_messenger(
          fl_view_get_engine(self->preview_api_view)),
      fl_engine_get_binary_messenger(fl_view_get_engine(self->preview_view)),
      self);

  monarch_channels_set_up_call_forwarding(self->channels);

  /**
   * @GOTCHA: the preview needs to be launched before the controller to make
   * sure the devtools widget inspector inspects the preview widget tree. This
   * is a workaround until [this issue]
   * (https://github.com/flutter/devtools/issues/4304) is solved.
   */
  show_window(self->preview_window, self->preview_view);
  show_window(self->controller_window, self->controller_view);
  show_window(self->preview_api_window, self->preview_api_view);
}

// Implements GApplication::local_command_line.
static gboolean monarch_application_local_command_line(
    GApplication* application, gchar*** arguments, int* exit_status) {
  MonarchApplication* self = MONARCH_APPLICATION(application);

  if (g_strv_length(*arguments) < 7) {
    g_warning(
        "Expected 7 arguments in this order: executable-path "
        "preview-api-bundle preview-window-bundle controller-bundle log-level "
        "cli-grpc-server-port project-name");
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
  g_clear_object(&self->channels);

  /** 
   * @GOTCHA: calling g_clear_object on FLView* instance members 
   * (preview_api_view, preview_view or controller_view) causes
   * error message when app exits:
   * (monarch_linux_app:167905): GLib-GObject-CRITICAL **: 15:03:46.169: g_object_unref: assertion 'G_IS_OBJECT (object)' failed
  */
  
  G_OBJECT_CLASS(monarch_application_parent_class)->dispose(object);
}

static void monarch_application_class_init(MonarchApplicationClass* klass) {
  G_APPLICATION_CLASS(klass)->activate = monarch_application_activate;
  G_APPLICATION_CLASS(klass)->local_command_line =
      monarch_application_local_command_line;
  G_OBJECT_CLASS(klass)->dispose = monarch_application_dispose;
}

static void monarch_application_init(MonarchApplication* self) {}

MonarchApplication* monarch_application_new() {
  return MONARCH_APPLICATION(
      g_object_new(monarch_application_get_type(), "application-id",
                   APPLICATION_ID, "flags", G_APPLICATION_NON_UNIQUE, nullptr));
}

struct GetStateData {
  GMainLoop* loop;
  MonarchApplication* monarch_application;
};

static void get_state_callback(GObject* object, GAsyncResult* result,
                               gpointer user_data) {
  GetStateData* get_state_data = static_cast<GetStateData*>(user_data);

  g_autoptr(GError) error = NULL;
  g_autoptr(FlMethodResponse) response = fl_method_channel_invoke_method_finish(
      FL_METHOD_CHANNEL(object), result, &error);

  if (response == NULL) {
    g_warning("Failed to invoke get_state method: %s", error->message);
    return;
  }

  if (FL_IS_METHOD_SUCCESS_RESPONSE(response)) {
    FlValue* result = fl_method_success_response_get_result(
        FL_METHOD_SUCCESS_RESPONSE(response));

    MonarchState* state = monarch_state_new_from_value(result);

    resize_preview_window(get_state_data->monarch_application,
                          monarch_state_get_device(state),
                          monarch_state_get_scale(state));
    set_preview_window_title(get_state_data->monarch_application,
                             monarch_state_get_device(state),
                             monarch_state_get_scale(state));
  }

  g_main_loop_quit(get_state_data->loop);
}

void monarch_application_update_preview_window(MonarchApplication* self) {
  g_autoptr(GMainLoop) loop = g_main_loop_new(nullptr, 0);

  GetStateData* get_state_data =
      new GetStateData(GetStateData{.loop = loop, .monarch_application = self});

  fl_method_channel_invoke_method(
      monarch_channels_get_preview_api_channel(self->channels),
      MonarchMethods::getState, nullptr, nullptr, get_state_callback,
      get_state_data);

  // Blocks here until get_state_callback is called
  g_main_loop_run(get_state_data->loop);

  delete get_state_data;
}

void monarch_application_restart_preview_window(MonarchApplication* self) {
  monarch_channels_send_will_close_preview(self->channels);
  gtk_widget_destroy(GTK_WIDGET(self->preview_window));

  g_autoptr(FlDartProject) preview_project =
      init_dart_project(get_preview_window_bundle_path(self));
  set_preview_args(self, preview_project);
  self->preview_view = fl_view_new(preview_project);
  self->preview_window = init_preview_window(G_APPLICATION(self));

  monarch_channels_restart_preview_channel(
      self->channels,
      fl_engine_get_binary_messenger(
          fl_view_get_engine(self->preview_api_view)),
      fl_engine_get_binary_messenger(fl_view_get_engine(self->preview_view)));

  show_window(self->preview_window, self->preview_view);
  monarch_application_update_preview_window(self);
}
