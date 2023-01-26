#ifndef MONARCH_STORY_SCALE_H_
#define MONARCH_STORY_SCALE_H_

#include <flutter_linux/flutter_linux.h>
#include <glib-object.h>

G_BEGIN_DECLS

G_DECLARE_FINAL_TYPE(MonarchStoryScale, monarch_story_scale, MONARCH,
                     STORY_SCALE, GObject)

MonarchStoryScale* monarch_story_scale_new(double scale, const gchar* name);
MonarchStoryScale* monarch_story_scale_new_from_value(FlValue* value);

double monarch_story_scale_get_scale(MonarchStoryScale* scale);
const gchar* monarch_story_scale_get_name(MonarchStoryScale* scale);

MonarchStoryScale* monarch_story_scale_get_default();

G_END_DECLS

#endif  // MONARCH_STORY_SCALE_H_