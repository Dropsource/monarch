#include "dock_side.h"

DockSide dockFromString(std::string dockString)
{
    if (dockString == "left") {
        return DockSide::left;
    }
    else if (dockString == "right") {
        return DockSide::right;
    }
    else if (dockString == "undock") {
        return DockSide::undock;
    }
    else {
        return DockSide::right;
    }
}
