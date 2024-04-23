#include "include/my_background_plugin/my_background_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "my_background_plugin.h"

void MyBackgroundPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  my_background_plugin::MyBackgroundPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
