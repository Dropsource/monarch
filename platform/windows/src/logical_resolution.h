#pragma once

#include "channels_utils.h"

struct LogicalResolution {
	double width;
	double height;

	LogicalResolution();
	LogicalResolution(double w, double h);
	LogicalResolution(EncodableMap args);
};
