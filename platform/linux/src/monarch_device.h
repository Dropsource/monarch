#ifndef MONARCH_DEVICE_H_
#define MONARCH_DEVICE_H_

#include <flutter_linux/flutter_linux.h>
#include <glib-object.h>

#include "monarch_logical_resolution.h"

G_BEGIN_DECLS

G_DECLARE_FINAL_TYPE(MonarchDevice, monarch_device, MONARCH, DEVICE, GObject)

typedef enum {
  MONARCH_TARGET_PLATFORM_IOS,
  MONARCH_TARGET_PLATFORM_ANDROID
} MonarchTargetPlatform;

MonarchDevice* monarch_device_new(const gchar* id, const gchar* name,
                                  MonarchLogicalResolution* logical_resolution,
                                  double device_pixel_ratio,
                                  MonarchTargetPlatform target_platform);

MonarchDevice* monarch_device_new_from_value(FlValue* value);

MonarchTargetPlatform monarch_target_platform_from_string(gchar* string);

MonarchLogicalResolution* monarch_device_get_logical_resolution(
    MonarchDevice* device);

const gchar* monarch_device_get_title(MonarchDevice* device);

MonarchDevice* monarch_device_get_default_device();

G_END_DECLS

#endif  // MONARCH_DEVICE_H_