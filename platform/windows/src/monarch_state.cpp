#include <vector>
#include "monarch_state.h"
#include "channels.h"

MonarchState::MonarchState(EncodableMap args)
{
	device = DeviceDefinition{ std::get<EncodableMap>(MapUtils::getValue(args, "device")) };
	scale = StoryScaleDefinition{ std::get<EncodableMap>(MapUtils::getValue(args, "scale")) };
	dock = dockFromString(std::get<std::string>(MapUtils::getValue(args, "dock")));
}
