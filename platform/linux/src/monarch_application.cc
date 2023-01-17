#include "monarch_application.h"

#include <flutter_linux/flutter_linux.h>

struct _MonarchApplication {
  GtkApplication parent_instance;
  char** command_line_arguments;
};

G_DEFINE_TYPE(MonarchApplication, monarch_application, GTK_TYPE_APPLICATION)


// static void __fl_dart_project_set_assets_path(FlDartProject* self,
//                                                      gchar* path) {
//   g_return_if_fail(FL_IS_DART_PROJECT(self));
//   g_clear_pointer(&self->assets_path, g_free);
//   self->assets_path = g_strdup(path);
// }

// Implements GApplication::activate.
static void monarch_application_activate(GApplication* application) {
  MonarchApplication* self = MONARCH_APPLICATION(application);
  GtkWindow* window =
      GTK_WINDOW(gtk_application_window_new(GTK_APPLICATION(application)));

  GtkHeaderBar* header_bar = GTK_HEADER_BAR(gtk_header_bar_new());
  gtk_widget_show(GTK_WIDGET(header_bar));
  gtk_header_bar_set_title(header_bar, "Monarch");
  gtk_header_bar_set_show_close_button(header_bar, TRUE);
  gtk_window_set_titlebar(window, GTK_WIDGET(header_bar));

  gtk_window_set_default_size(window, 1280, 720);
  gtk_widget_show(GTK_WIDGET(window));

  g_autoptr(FlDartProject) project = fl_dart_project_new();
  //char assets_path[] = "/home/fertrig/development/monarch_product/monarch/out/monarch/bin/cache/monarch_ui/flutter_linux_3.7.0-21.0.pre.44-master/monarch_controller/flutter_assets";
  //char icu_path[] = "/home/fertrig/development/monarch_product/monarch/out/monarch/bin/cache/monarch_ui/flutter_linux_3.7.0-21.0.pre.44-master/monarch_controller/icudtl.dat";
  
  char assets_path[] = "/home/fertrig/development/scratch/hair/build/linux/x64/debug/bundle/data/flutter_assets";
  char icu_path[] = "/home/fertrig/development/scratch/hair/build/linux/x64/debug/bundle/data/icudtl.dat";
  
  fl_dart_project_set_assets_path(project, assets_path);
  fl_dart_project_set_icu_data_path(project, icu_path);
  // project->assets_path = g_strdup(assets_path);
  fl_dart_project_set_dart_entrypoint_arguments(project, self->command_line_arguments);

  FlView* view = fl_view_new(project);
  gtk_widget_show(GTK_WIDGET(view));
  gtk_container_add(GTK_CONTAINER(window), GTK_WIDGET(view));

  gtk_widget_grab_focus(GTK_WIDGET(view));
}

// Implements GApplication::local_command_line.
static gboolean monarch_application_local_command_line(GApplication* application, gchar*** arguments, int* exit_status) {
  MonarchApplication* self = MONARCH_APPLICATION(application);
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