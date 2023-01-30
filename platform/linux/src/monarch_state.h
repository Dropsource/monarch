#ifndef MONARCH_STATE_H_
#define MONARCH_STATE_H_

#include <flutter_linux/flutter_linux.h>
#include <glib-object.h>

#include "monarch_device.h"
#include "monarch_story_scale.h"

G_BEGIN_DECLS

G_DECLARE_FINAL_TYPE(MonarchState, monarch_state, MONARCH, STATE, GObject)

MonarchState* monarch_state_new_from_value(FlValue* value);

MonarchDevice* monarch_state_get_device(MonarchState* state);
MonarchStoryScale* monarch_state_get_scale(MonarchState* state);

G_END_DECLS

#endif  // MONARCH_STATE_H_