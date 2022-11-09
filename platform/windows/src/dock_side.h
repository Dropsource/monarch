#pragma once

#include <array>
#include <string>

enum class DockSide {
    right, left, undock
};

const DockSide defaultDockSide = DockSide::right;

DockSide dockFromString(std::string dockString);
