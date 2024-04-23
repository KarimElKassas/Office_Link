import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foe_archiving/app/app.dart';
import 'package:foe_archiving/core/di/service_locator.dart';
import 'package:foe_archiving/core/helpers/notification_service.dart';
import 'package:foe_archiving/core/theming/language_manager.dart';
import 'package:foe_archiving/core/utils/bloc_observer.dart';
import 'package:foe_archiving/core/utils/dio_helper.dart';
import 'package:foe_archiving/core/utils/prefs_helper.dart';
import 'package:local_notifier/local_notifier.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:window_manager/window_manager.dart';

import 'core/utils/app_version.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Preference.load();
  await NotificationService.init();


  DioHelper.init();
  Bloc.observer = MyBlocObserver();
  ServiceLocator().setup();

  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  var currentVersion = "${packageInfo.version.replaceAll(".", "")}0";
  Constants.currentVersionNumber = int.parse(currentVersion);

  windowManager.setTitle("ارشيف مستقبل مصر");
  windowManager.maximize();
  windowManager.setResizable(false);

  bool needUpdate = await checkForUpdate();
  if(needUpdate){
    print("NEED UPDATE \n");
    var myPath = r"\\172.16.9.43\System\Archiving\versions";
    var myFile = "foe_archiving_${Constants.latestVersion}.msix";
    ProcessResult result = await Process.run('cmd', ['/c', 'start', '', '$myPath/$myFile']);

    if (result.exitCode == 0) {
      await windowManager.destroy();
    }
    else {
      print("Bad ${result.stdout}\n");
      runApp(EasyLocalization(
          supportedLocales: const [ARABIC_LOCAL, ENGLISH_LOCAL],
          path: ASSET_PATH_LOCALISATIONS,
          child: MyApp(Constants.currentTheme)
      ));
    }
  }else{
    print("BIG ELSE\n");
    //initWindow();

    runApp(EasyLocalization(
        supportedLocales: const [ARABIC_LOCAL, ENGLISH_LOCAL],
        path: ASSET_PATH_LOCALISATIONS,
        child: MyApp(Constants.currentTheme)
    ));
  }
  runApp(EasyLocalization(
      supportedLocales: const [ARABIC_LOCAL, ENGLISH_LOCAL],
      path: ASSET_PATH_LOCALISATIONS,
      child: MyApp(Constants.currentTheme)
  ));
}
