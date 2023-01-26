#include "monarch_state.h"

struct _MonarchState {
  GObject parent_instance;

  MonarchDevice* device;
  MonarchStoryScale* scale;
};

G_DEFINE_TYPE(MonarchState, monarch_state, G_TYPE_OBJECT)

static void monarch_state_dispose(GObject* object) {
  MonarchState* self = MONARCH_STATE(object);

  g_clear_object(&self->device);
  g_clear_object(&self->scale);

  G_OBJECT_CLASS(monarch_state_parent_class)->dispose(object);
}

static void monarch_state_class_init(MonarchStateClass* klass) {
  G_OBJECT_CLASS(klass)->dispose = monarch_state_dispose;
}

static void monarch_state_init(MonarchState* self) {}

MonarchState* monarch_state_new_from_value(FlValue* value) {
  MonarchState* self =
      MONARCH_STATE(g_object_new(monarch_state_get_type(), nullptr));

  FlValue* v = fl_value_lookup_string(value, "device");
  self->device = monarch_device_new_from_value(v);

  v = fl_value_lookup_string(value, "scale");
  self->scale = monarch_story_scale_new_from_value(v);

  return self;
}

MonarchDevice* monarch_state_get_device(MonarchState* self) {
  return self->device;
}

MonarchStoryScale* monarch_state_get_scale(MonarchState* self) {
  return self->scale;
}
