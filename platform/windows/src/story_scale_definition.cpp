#include "story_scale_definition.h"
#include "channels.h"

StoryScaleDefinition::StoryScaleDefinition()
{
	scale = defaultStoryScaleDefinition.scale;
	name = defaultStoryScaleDefinition.name;
}

StoryScaleDefinition::StoryScaleDefinition(double _scale, std::string _name)
{
	scale = _scale;
	name = _name;
}

StoryScaleDefinition::StoryScaleDefinition(EncodableMap args)
{
	scale = std::get<double>(MapUtils::getValue(args, "scale"));
	name = std::get<std::string>(MapUtils::getValue(args, "name"));
}

StoryScaleDefinition defaultStoryScaleDefinition = StoryScaleDefinition{
	1.0,
	"100%"
};
