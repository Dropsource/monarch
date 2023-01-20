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


struct ForwardInfo {
  FlMethodChannel* from;
  FlMethodChannel* to;
};

struct MethodCallInfo {
  FlMethodCall* original_call;
};

void forwarded_method_call_response(GObject *object,
                                    GAsyncResult *result,
                                    gpointer user_data) {
  MethodCallInfo* method_call_info = static_cast<MethodCallInfo*>(user_data);
  
  g_autoptr(GError) error = NULL;
  g_autoptr(FlMethodResponse) response =
      fl_method_channel_invoke_method_finish(FL_METHOD_CHANNEL(object), result, &error);

  if (response == NULL)
  {
    g_warning("Failed to invoke forwarded method %s: %s", 
              fl_method_call_get_name(method_call_info->original_call), 
              error->message);
    return;
  }

  if (FL_IS_METHOD_SUCCESS_RESPONSE(response))
  {
    g_autoptr(FlValue) result = fl_method_success_response_get_result(FL_METHOD_SUCCESS_RESPONSE(response));

    if (!fl_method_call_respond_success(method_call_info->original_call, result, &error)) {
      g_warning("Failed to send response to original method %s: %s",
                fl_method_call_get_name(method_call_info->original_call), 
                error->message);
      return;
    }

    // if (!fl_method_call_respond(method_call_info->original_call, response, &error)) {
    //   g_warning("Failed to send response to original method %s: %s",
    //             fl_method_call_get_name(method_call_info->original_call), 
    //             error->message);
    //   return;
    // }
  }
  else if (FL_IS_METHOD_ERROR_RESPONSE(response))
  {
    FlMethodErrorResponse *error_response = FL_METHOD_ERROR_RESPONSE(response);
    if (!fl_method_call_respond_error(
            method_call_info->original_call, 
            fl_method_error_response_get_code(error_response),
            fl_method_error_response_get_message(error_response),
            fl_method_error_response_get_details(error_response),
            &error)) {
      g_warning("Failed to send error response to original method %s: %s",
                fl_method_call_get_name(method_call_info->original_call), 
                error->message);
      return;
    }

    // if (!fl_method_call_respond(method_call_info->original_call, error_response, &error)) {
    //   g_warning("Failed to send error response to original method %s: %s",
    //             fl_method_call_get_name(method_call_info->original_call), 
    //             error->message);
    //   return;
    // }

    // handle_error(fl_method_error_response_get_code(error_response),
    //              fl_method_error_response_get_message(error_response),
    //              fl_method_error_response_get_details(error_response));
  }
  else if (FL_IS_METHOD_NOT_IMPLEMENTED_RESPONSE(response))
  {
    if (!fl_method_call_respond_not_implemented(method_call_info->original_call, &error)) {
      g_warning("Failed to send not implemented response to original method %s: %s",
                fl_method_call_get_name(method_call_info->original_call), 
                error->message);
      return;
    }
  }
}

void forward_method_call(FlMethodChannel* channel,
                         FlMethodCall* method_call,
                         gpointer user_data) {
  ForwardInfo* info = static_cast<ForwardInfo*>(user_data);

  MethodCallInfo method_call_info {
    .original_call = method_call
  };

  fl_method_channel_invoke_method(
      info->to, 
      fl_method_call_get_name(method_call), 
      fl_method_call_get_args(method_call), 
      nullptr, 
      forwarded_method_call_response,
      &method_call_info);
}

void set_up_call_forwarding(MonarchChannels* self)
{
  ForwardInfo to_preview_api {
    .from = self->preview_channel,
    .to = self->preview_api_channel
  };

  fl_method_channel_set_method_call_handler(
      self->preview_channel, 
      forward_method_call,
      &to_preview_api, NULL);

  ForwardInfo to_preview {
    .from = self->preview_api_channel,
    .to = self->preview_channel
  };
  
  fl_method_channel_set_method_call_handler(
      self->preview_api_channel,
      forward_method_call,
      &to_preview, NULL);
}
