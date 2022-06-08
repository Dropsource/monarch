#include "logical_resolution.h"

LogicalResolution::LogicalResolution()
{
	width = 0;
	height = 0;
}

LogicalResolution::LogicalResolution(double w, double h)
{
	width = w;
	height = h;
}

LogicalResolution::LogicalResolution(flutter::EncodableMap args)
{
	width = std::get<double>(MapUtils::getValue(args, "width"));
	height = std::get<double>(MapUtils::getValue(args, "height"));
}
