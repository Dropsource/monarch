#ifndef MONARCH_CHANNELS_H_
#define MONARCH_CHANNELS_H_

#include <flutter_linux/flutter_linux.h>
#include <glib-object.h>

#include "monarch_application.h"

G_BEGIN_DECLS

G_DECLARE_FINAL_TYPE(MonarchChannels, monarch_channels, MONARCH, CHANNELS,
                     GObject)

MonarchChannels* monarch_channels_new(FlBinaryMessenger* preview_api_messenger,
                                      FlBinaryMessenger* preview_messenger,
                                      MonarchApplication* monarch_application);

void monarch_channels_set_up_call_forwarding(MonarchChannels* channels);

FlMethodChannel* monarch_channels_get_preview_api_channel(MonarchChannels* channels);

constexpr char preview_api_channel_name[] = "monarch.previewApi";
constexpr char preview_channel_name[] = "monarch.previewWindow";

namespace MonarchMethods {
constexpr char setActiveDevice[] = "monarch.setActiveDevice";
constexpr char setStoryScale[] = "monarch.setStoryScale";
constexpr char setDockSide[] = "monarch.setDockSide";
constexpr char getState[] = "monarch.getState";
constexpr char screenChanged[] = "monarch.screenChanged";
constexpr char restartPreview[] = "monarch.restartPreview";
constexpr char willClosePreview[] = "monarch.willClosePreview";
constexpr char terminatePreview[] = "monarch.terminatePreview";
};  // namespace MonarchMethods

G_END_DECLS

#endif  // MONARCH_CHANNELS_H_
