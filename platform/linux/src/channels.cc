#include "channels.h"

static constexpr char preview_api_channel_name[] = "monarch.previewApi";
static constexpr char preview_channel_name[] = "monarch.previewWindow";

struct _MonarchChannels
{
  GObject parent_instance;

  FlMethodChannel* preview_api_channel;
  FlMethodChannel* preview_channel;
};

G_DEFINE_TYPE(MonarchChannels, monarch_channels, G_TYPE_OBJECT)

static void monarch_channels_dispose(GObject* object) {
  MonarchChannels* self = MONARCH_CHANNELS(object);

  g_clear_object(&self->preview_api_channel);
  g_clear_object(&self->preview_channel);

  G_OBJECT_CLASS(monarch_channels_parent_class)->dispose(object);
}

static void monarch_channels_class_init(MonarchChannelsClass* klass) {
  G_OBJECT_CLASS(klass)->dispose = monarch_channels_dispose;
}

static void monarch_channels_init(MonarchChannels* self) {}

MonarchChannels* monarch_channels_new(FlBinaryMessenger* preview_api_messenger,
                                      FlBinaryMessenger* preview_messenger)
{
  MonarchChannels* self = MONARCH_CHANNELS(g_object_new(monarch_channels_get_type(), nullptr));

  g_autoptr(FlStandardMethodCodec) codec = fl_standard_method_codec_new();

  self->preview_api_channel = 
      fl_method_channel_new(preview_api_messenger, preview_api_channel_name, FL_METHOD_CODEC(codec));

  self->preview_channel = 
      fl_method_channel_new(preview_messenger, preview_channel_name, FL_METHOD_CODEC(codec));

  return self;
}

void set_up_call_forwarding(MonarchChannels* channels)
{
  
}
