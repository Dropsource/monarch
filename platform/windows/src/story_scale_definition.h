#pragma once

#include <string>
#include "channels_utils.h"

struct StoryScaleDefinition {
	double scale;
	std::string name;
	
	StoryScaleDefinition();

	StoryScaleDefinition(
		double _scale,
		std::string _name);

	StoryScaleDefinition(EncodableMap args);
};

extern StoryScaleDefinition defaultStoryScaleDefinition;
