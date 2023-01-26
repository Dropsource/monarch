#include "monarch_story_scale.h"

struct _MonarchStoryScale {
  GObject parent_instance;

  double scale;
  gchar* name;
};

G_DEFINE_TYPE(MonarchStoryScale, monarch_story_scale, G_TYPE_OBJECT)

static void monarch_story_scale_dispose(GObject* object) {
  MonarchStoryScale* self = MONARCH_STORY_SCALE(object);

  g_clear_pointer(&self->name, g_free);

  G_OBJECT_CLASS(monarch_story_scale_parent_class)->dispose(object);
}

static void monarch_story_scale_class_init(MonarchStoryScaleClass* klass) {
  G_OBJECT_CLASS(klass)->dispose = monarch_story_scale_dispose;
}

static void monarch_story_scale_init(MonarchStoryScale* self) {}

MonarchStoryScale* monarch_story_scale_new(double scale, gchar* name) {
  MonarchStoryScale* self = MONARCH_STORY_SCALE(
      g_object_new(monarch_story_scale_get_type(), nullptr));

  self->scale = scale;
  self->name = name;

  return self;
}

MonarchStoryScale* monarch_story_scale_new_from_value(FlValue* value) {
  MonarchStoryScale* self = MONARCH_STORY_SCALE(
      g_object_new(monarch_story_scale_get_type(), nullptr));

  FlValue* v = fl_value_lookup_string(value, "scale");
  self->scale = fl_value_get_float(v);

  v = fl_value_lookup_string(value, "name");
  self->name = g_strdup(fl_value_get_string(v));

  return self;
}

double monarch_story_scale_get_scale(MonarchStoryScale* self) {
  return self->scale;
}

gchar* monarch_story_scale_get_name(MonarchStoryScale* self) {
  return self->name;
}
