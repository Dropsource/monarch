#ifndef MONARCH_LOGICAL_RESOLUTION_H_
#define MONARCH_LOGICAL_RESOLUTION_H_

#include <flutter_linux/flutter_linux.h>
#include <glib-object.h>

G_BEGIN_DECLS

G_DECLARE_FINAL_TYPE(MonarchLogicalResolution, monarch_logical_resolution,
                     MONARCH, LOGICAL_RESOLUTION, GObject)

MonarchLogicalResolution* monarch_logical_resolution_new(double w, double h);
MonarchLogicalResolution* monarch_logical_resolution_new_from_value(
    FlValue* value);

double monarch_logical_resolution_get_width(MonarchLogicalResolution* logical_resolution);
double monarch_logical_resolution_get_height(MonarchLogicalResolution* logical_resolution);

G_END_DECLS

#endif  // MONARCH_LOGICAL_RESOLUTION_H_