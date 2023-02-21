#include "channels.h"

struct _MonarchChannels {
  GObject parent_instance;

  FlMethodChannel* preview_api_channel;
  FlMethodChannel* preview_channel;
  MonarchApplication* monarch_application;
};

G_DEFINE_TYPE(MonarchChannels, monarch_channels, G_TYPE_OBJECT)

static void monarch_channels_dispose(GObject* object) {
  MonarchChannels* self = MONARCH_CHANNELS(object);

  g_clear_object(&self->preview_api_channel);
  g_clear_object(&self->preview_channel);

  if (self->monarch_application != nullptr) {
    g_object_remove_weak_pointer(
        G_OBJECT(self),
        reinterpret_cast<gpointer*>(&(self->monarch_application)));
    self->monarch_application = nullptr;
  }

  G_OBJECT_CLASS(monarch_channels_parent_class)->dispose(object);
}

static void monarch_channels_class_init(MonarchChannelsClass* klass) {
  G_OBJECT_CLASS(klass)->dispose = monarch_channels_dispose;
}

static void monarch_channels_init(MonarchChannels* self) {}

MonarchChannels* monarch_channels_new(FlBinaryMessenger* preview_api_messenger,
                                      FlBinaryMessenger* preview_messenger,
                                      MonarchApplication* monarch_application) {
  MonarchChannels* self =
      MONARCH_CHANNELS(g_object_new(monarch_channels_get_type(), nullptr));

  g_autoptr(FlStandardMethodCodec) codec = fl_standard_method_codec_new();

  self->preview_api_channel = fl_method_channel_new(
      preview_api_messenger, preview_api_channel_name, FL_METHOD_CODEC(codec));

  self->preview_channel = fl_method_channel_new(
      preview_messenger, preview_channel_name, FL_METHOD_CODEC(codec));

  self->monarch_application = monarch_application;

  g_object_add_weak_pointer(G_OBJECT(self), reinterpret_cast<gpointer*>(
                                                &(self->monarch_application)));

  return self;
}

struct MethodCallInfo {
  GMainLoop* loop;
  FlMethodCall* original_call;
};

static void destination_method_call_response(GObject* object,
                                             GAsyncResult* result,
                                             gpointer user_data) {
  MethodCallInfo* method_call_info = static_cast<MethodCallInfo*>(user_data);
  FlMethodCall* original_method_call = method_call_info->original_call;

  g_autoptr(GError) error = NULL;
  g_autoptr(FlMethodResponse) response = fl_method_channel_invoke_method_finish(
      FL_METHOD_CHANNEL(object), result, &error);

  if (response == NULL) {
    g_warning("Failed to invoke forwarded method %s: %s",
              fl_method_call_get_name(original_method_call), error->message);
    return;
  }

  if (FL_IS_METHOD_SUCCESS_RESPONSE(response)) {
    FlValue* result = fl_method_success_response_get_result(
        FL_METHOD_SUCCESS_RESPONSE(response));

    // `fl_value_ref(result)` may be useful if we need to increment the
    // reference count of the result:
    //
    // if (!fl_method_call_respond_success(original_method_call,
    // fl_value_ref(result), &error))

    if (!fl_method_call_respond_success(original_method_call, result, &error)) {
      g_warning("Failed to send response to original method %s: %s",
                fl_method_call_get_name(original_method_call), error->message);
      return;
    }

    // This is another way to respond to the original call using
    // `fl_method_call_respond`:
    //
    // g_autoptr(FlMethodResponse) response =
    // FL_METHOD_RESPONSE(fl_method_success_response_new(result)); if
    // (!fl_method_call_respond(original_method_call, response, &error)) {
    //   g_warning("Failed to send response to original method %s: %s",
    //             fl_method_call_get_name(original_method_call),
    //             error->message);
    //   return;
    // }
  } else if (FL_IS_METHOD_ERROR_RESPONSE(response)) {
    FlMethodErrorResponse* error_response = FL_METHOD_ERROR_RESPONSE(response);
    if (!fl_method_call_respond_error(
            original_method_call,
            fl_method_error_response_get_code(error_response),
            fl_method_error_response_get_message(error_response),
            fl_method_error_response_get_details(error_response), &error)) {
      g_warning("Failed to send error response to original method %s: %s",
                fl_method_call_get_name(original_method_call), error->message);
      return;
    }

    // This is another way to respond to the original call using
    // `fl_method_call_respond`:
    //
    // if (!fl_method_call_respond(method_call, error_response, &error)) {
    //   g_warning("Failed to send error response to original method %s: %s",
    //             fl_method_call_get_name(method_call),
    //             error->message);
    //   return;
    // }
  } else if (FL_IS_METHOD_NOT_IMPLEMENTED_RESPONSE(response)) {
    if (!fl_method_call_respond_not_implemented(original_method_call, &error)) {
      g_warning(
          "Failed to send not implemented response to original method %s: %s",
          fl_method_call_get_name(original_method_call), error->message);
      return;
    }
  }

  g_main_loop_quit(method_call_info->loop);
}

static void forward_method_call(FlMethodChannel* channel,
                                FlMethodCall* method_call, gpointer user_data) {
  FlMethodChannel* destination_channel =
      static_cast<FlMethodChannel*>(user_data);
  if (destination_channel == nullptr) {
    g_error("destination_channel is nullptr");
  }

  g_autoptr(GMainLoop) loop = g_main_loop_new(nullptr, 0);

  MethodCallInfo* method_call_info = new MethodCallInfo(
      MethodCallInfo{.loop = loop, .original_call = method_call});

  fl_method_channel_invoke_method(
      destination_channel, fl_method_call_get_name(method_call),
      fl_method_call_get_args(method_call), nullptr,
      destination_method_call_response, method_call_info);

  // Blocks here until destination_method_call_response is called
  g_main_loop_run(method_call_info->loop);

  delete method_call_info;
}

static void forward_method_call_from_preview(FlMethodChannel* channel,
                                             FlMethodCall* method_call,
                                             gpointer user_data) {
  MonarchChannels* monarch_channels = static_cast<MonarchChannels*>(user_data);

  // forward to preview_api
  forward_method_call(channel, method_call,
                      monarch_channels->preview_api_channel);
}

static void forward_method_call_from_preview_api(FlMethodChannel* channel,
                                                 FlMethodCall* method_call,
                                                 gpointer user_data) {
  MonarchChannels* monarch_channels = static_cast<MonarchChannels*>(user_data);

  // forward to preview
  forward_method_call(channel, method_call, monarch_channels->preview_channel);

  const gchar* method = fl_method_call_get_name(method_call);

  if (strcmp(method, MonarchMethods::setActiveDevice) == 0 ||
      strcmp(method, MonarchMethods::setStoryScale) == 0) {
    monarch_application_update_preview_window(
        monarch_channels->monarch_application);
  } else if (strcmp(method, MonarchMethods::setDockSide) == 0) {
    // TODO: implement docking
  } else if (strcmp(method, MonarchMethods::restartPreview) == 0) {
    monarch_application_restart_preview_window(
        monarch_channels->monarch_application);
  } else if (strcmp(method, MonarchMethods::terminatePreview) == 0) {
    // TODO: implement terminate preview (not sure if really needed)
  } else {
    // no-op
  }
}

void monarch_channels_set_up_call_forwarding(MonarchChannels* self) {
  // forward method calls from preview to preview_api
  fl_method_channel_set_method_call_handler(
      self->preview_channel,             // original channel
      forward_method_call_from_preview,  // handler
      self,                              // user_data or destination channel
      NULL);

  // forward method calls from preview_api to preview
  fl_method_channel_set_method_call_handler(
      self->preview_api_channel,             // original channel
      forward_method_call_from_preview_api,  // handler
      self,                                  // user_data or destination channel
      NULL);
}

FlMethodChannel* monarch_channels_get_preview_api_channel(
    MonarchChannels* self) {
  g_return_val_if_fail(MONARCH_IS_CHANNELS(self), nullptr);
  return self->preview_api_channel;
}

void monarch_channels_send_will_close_preview(MonarchChannels* self) {
  fl_method_channel_invoke_method(self->preview_channel,
                                  MonarchMethods::willClosePreview, nullptr,
                                  nullptr, nullptr, nullptr);
  fl_method_channel_invoke_method(self->preview_api_channel,
                                  MonarchMethods::willClosePreview, nullptr,
                                  nullptr, nullptr, nullptr);
}

void monarch_channels_restart_preview_channel(
    MonarchChannels* self, FlBinaryMessenger* preview_api_messenger,
    FlBinaryMessenger* preview_messenger) {

  // g_clear_object(&self->preview_channel);
  // g_clear_object(&self->preview_api_channel);

  g_autoptr(FlStandardMethodCodec) codec = fl_standard_method_codec_new();

  self->preview_api_channel = fl_method_channel_new(
      preview_api_messenger, preview_api_channel_name, FL_METHOD_CODEC(codec));

  self->preview_channel = fl_method_channel_new(
      preview_messenger, preview_channel_name, FL_METHOD_CODEC(codec));

  monarch_channels_set_up_call_forwarding(self);
}
