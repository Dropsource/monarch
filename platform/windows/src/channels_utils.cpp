#include "channels_utils.h"
#include <stdexcept>

const EncodableValue& MapUtils::getValue(const EncodableMap& map, const std::string& key)
{
	auto itr = map.find(EncodableValue(key));
	if (itr == map.end()) {
		throw std::runtime_error{ "Expected to find key [" + key + "] in map" };
	}
	return itr->second;
}
