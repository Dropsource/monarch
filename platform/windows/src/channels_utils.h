#pragma once

#include <flutter/standard_method_codec.h>

using EncodableList = flutter::EncodableList;
using EncodableMap = flutter::EncodableMap;
using EncodableValue = flutter::EncodableValue;

namespace MapUtils
{
	const flutter::EncodableValue& getValue(
		const flutter::EncodableMap& map,
		const std::string& key);
}
