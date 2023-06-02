#include "monarch_device.h"

struct _MonarchDevice {
  GObject parent_instance;

  const gchar* id;
  const gchar* name;
  MonarchLogicalResolution* logical_resolution;
  double device_pixel_ratio;
  MonarchTargetPlatform target_platform;
};

G_DEFINE_TYPE(MonarchDevice, monarch_device, G_TYPE_OBJECT)

static void monarch_device_dispose(GObject* object) {
  MonarchDevice* self = MONARCH_DEVICE(object);

  g_clear_object(&self->logical_resolution);

  G_OBJECT_CLASS(monarch_device_parent_class)->dispose(object);
}

static void monarch_device_class_init(MonarchDeviceClass* klass) {
  G_OBJECT_CLASS(klass)->dispose = monarch_device_dispose;
}

static void monarch_device_init(MonarchDevice* self) {}

MonarchDevice* monarch_device_new(const gchar* id, const gchar* name,
                                  MonarchLogicalResolution* logical_resolution,
                                  double device_pixel_ratio,
                                  MonarchTargetPlatform target_platform) {
  MonarchDevice* self =
      MONARCH_DEVICE(g_object_new(monarch_device_get_type(), nullptr));

  self->id = id;
  self->name = name;
  self->logical_resolution = logical_resolution;
  self->device_pixel_ratio = device_pixel_ratio;
  self->target_platform = target_platform;

  return self;
}

MonarchDevice* monarch_device_new_from_value(FlValue* value) {
  MonarchDevice* self =
      MONARCH_DEVICE(g_object_new(monarch_device_get_type(), nullptr));

  FlValue* v = fl_value_lookup_string(value, "id");
  self->id = fl_value_get_string(v);

  v = fl_value_lookup_string(value, "name");
  self->name = fl_value_get_string(v);

  v = fl_value_lookup_string(value, "logicalResolution");
  self->logical_resolution = monarch_logical_resolution_new_from_value(v);

  v = fl_value_lookup_string(value, "devicePixelRatio");
  self->device_pixel_ratio = fl_value_get_float(v);

  v = fl_value_lookup_string(value, "targetPlatform");
  self->target_platform =
      monarch_target_platform_from_string(g_strdup(fl_value_get_string(v)));

  return self;
}

MonarchTargetPlatform monarch_target_platform_from_string(gchar* string) {
  if (strcmp(string, "ios") == 0) {
    return MONARCH_TARGET_PLATFORM_IOS;
  } else {
    return MONARCH_TARGET_PLATFORM_ANDROID;
  }
}

MonarchLogicalResolution* monarch_device_get_logical_resolution(
    MonarchDevice* self) {
  return self->logical_resolution;
}

const gchar* monarch_device_get_title(MonarchDevice* self) {
  g_autoptr(GString) title = g_string_new("");
  g_string_append_printf(
      title, "%.0fx%.0f | %s",
      monarch_logical_resolution_get_width(self->logical_resolution),
      monarch_logical_resolution_get_height(self->logical_resolution),
      self->name);

  return g_strdup(title->str);
}

MonarchDevice* monarch_device_get_default_device() {
  return monarch_device_new("ios-iphone-14", "iPhone 14",
                            monarch_logical_resolution_new(390.0, 844.0), 3.0,
                            MONARCH_TARGET_PLATFORM_IOS);
}
