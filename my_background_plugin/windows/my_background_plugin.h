#ifndef FLUTTER_PLUGIN_MY_BACKGROUND_PLUGIN_H_
#define FLUTTER_PLUGIN_MY_BACKGROUND_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace my_background_plugin {

class MyBackgroundPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  MyBackgroundPlugin();

  virtual ~MyBackgroundPlugin();

  // Disallow copy and assign.
  MyBackgroundPlugin(const MyBackgroundPlugin&) = delete;
  MyBackgroundPlugin& operator=(const MyBackgroundPlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace my_background_plugin

#endif  // FLUTTER_PLUGIN_MY_BACKGROUND_PLUGIN_H_
