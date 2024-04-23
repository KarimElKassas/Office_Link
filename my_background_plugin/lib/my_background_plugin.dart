
import 'my_background_plugin_platform_interface.dart';

class MyBackgroundPlugin {
  Future<String?> getPlatformVersion() {
    return MyBackgroundPluginPlatform.instance.getPlatformVersion();
  }
}
