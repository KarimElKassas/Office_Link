#include "include/plugin_name/plugin_name_plugin.h"

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>
#include <flutter/standard_method_codec.h>

namespace {
    class PluginNamePlugin : public flutter::Plugin {
    public:
        static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

        PluginNamePlugin();

        virtual ~PluginNamePlugin();

    private:
        // Method channel for communication with Flutter
        std::unique_ptr<flutter::MethodChannel<>> channel_;
    };

// Register the plugin
    void PluginNamePlugin::RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar) {
        auto channel = std::make_unique<flutter::MethodChannel<>>(
                registrar->messenger(), "my_background",
                &flutter::StandardMethodCodec::GetInstance());

        auto plugin = std::make_unique<PluginNamePlugin>();
        plugin->channel_ = std::move(channel);
    }

    PluginNamePlugin::PluginNamePlugin() {}

    PluginNamePlugin::~PluginNamePlugin() {}

} // namespace

void PluginNamePluginRegisterWithRegistrar(
        FlutterDesktopPluginRegistrarRef registrar) {
    PluginNamePlugin::RegisterWithRegistrar(
            flutter::PluginRegistrarManager::GetInstance()
                    ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
