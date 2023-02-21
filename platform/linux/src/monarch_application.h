#ifndef MONARCH_APPLICATION_H_
#define MONARCH_APPLICATION_H_

#include <gtk/gtk.h>

G_DECLARE_FINAL_TYPE(MonarchApplication, 
                     monarch_application, 
                     MONARCH, 
                     APPLICATION,
                     GtkApplication)

MonarchApplication* monarch_application_new();

void monarch_application_update_preview_window(MonarchApplication* application);

void monarch_application_restart_preview_window(MonarchApplication* application);

#endif // MONARCH_APPLICATION_H_
