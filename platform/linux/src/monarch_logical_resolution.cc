#include "monarch_logical_resolution.h"

struct _MonarchLogicalResolution {
  GObject parent_instance;

  double width;
  double height;
};

G_DEFINE_TYPE(MonarchLogicalResolution, monarch_logical_resolution,
              G_TYPE_OBJECT)

static void monarch_logical_resolution_dispose(GObject* object) {
  G_OBJECT_CLASS(monarch_logical_resolution_parent_class)->dispose(object);
}

static void monarch_logical_resolution_class_init(
    MonarchLogicalResolutionClass* klass) {
  G_OBJECT_CLASS(klass)->dispose = monarch_logical_resolution_dispose;
}

static void monarch_logical_resolution_init(MonarchLogicalResolution* self) {}

MonarchLogicalResolution* monarch_logical_resolution_new(double w, double h) {
  MonarchLogicalResolution* self = MONARCH_LOGICAL_RESOLUTION(
      g_object_new(monarch_logical_resolution_get_type(), nullptr));

  self->width = w;
  self->height = h;

  return self;
}

MonarchLogicalResolution* monarch_logical_resolution_new_from_value(
    FlValue* value) {
  MonarchLogicalResolution* self = MONARCH_LOGICAL_RESOLUTION(
      g_object_new(monarch_logical_resolution_get_type(), nullptr));

  FlValue* v = fl_value_lookup_string(value, "width");
  self->width = fl_value_get_float(v);

  v = fl_value_lookup_string(value, "height");
  self->height = fl_value_get_float(v);

  return self;
}

double monarch_logical_resolution_get_width(
    MonarchLogicalResolution* self) {
  return self->width;
}

double monarch_logical_resolution_get_height(
    MonarchLogicalResolution* self) {
  return self->height;
}
