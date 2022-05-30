#pragma once

#include <vector>
#include "dock_side.h"
#include "device_definition.h"
#include "story_scale_definition.h"
#include "channels_utils.h"

struct MonarchState
{
    DeviceDefinition device;
    StoryScaleDefinition scale;
    DockSide dock;

    MonarchState(EncodableMap args);
};