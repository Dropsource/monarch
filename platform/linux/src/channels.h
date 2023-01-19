#ifndef MONARCH_CHANNELS_H_
#define MONARCH_CHANNELS_H_

#include <glib-object.h>

#include <flutter_linux/flutter_linux.h>

G_BEGIN_DECLS

G_DECLARE_FINAL_TYPE(MonarchChannels, 
                     monarch_channels, 
                     MONARCH, 
                     CHANNELS,
                     GObject)

MonarchChannels* monarch_channels_new(FlBinaryMessenger* preview_api_messenger,
                                      FlBinaryMessenger* preview_messenger);

void set_up_call_forwarding(MonarchChannels* channels);

G_END_DECLS

#endif // MONARCH_CHANNELS_H_
