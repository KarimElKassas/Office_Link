import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:foe_archiving/core/routing/app_router.dart';
import 'package:foe_archiving/core/routing/routes.dart';
import 'package:sizer/sizer.dart' as res;
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

import '../core/localization/strings_manager.dart';
import '../core/theming/theme_manager.dart';


class MyApp extends StatefulWidget {

  const MyApp._internal(this.initialTheme);

  static const _instance = MyApp._internal(AdaptiveThemeMode.dark);

  final AdaptiveThemeMode? initialTheme;
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  factory MyApp(AdaptiveThemeMode? initialTheme) => _instance;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {

  @override
  void didChangeDependencies() {
    context.setLocale(const Locale("ar", "EG"));
    super.didChangeDependencies();
  }

  GlobalKey key = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return res.Sizer(
      builder: (context, orientation, deviceType){
        return AdaptiveTheme(
          light: ThemeManager().getLightTheme(),
          dark: ThemeManager().getDarkTheme(),
          initial: widget.initialTheme ?? ThemeManager().getDarkTheme(),
          builder: (theme, darkTheme) => MaterialApp(
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            title: AppStrings.archiveApp.tr(),
            key: key,
            navigatorKey: MyApp.navigatorKey,
            navigatorObservers: [FlutterSmartDialog.observer],
            builder: FlutterSmartDialog.init(),
            debugShowCheckedModeBanner: false,
            onGenerateRoute: AppRouter.getRoute,
            initialRoute: Routes.splashRoute, //Platform.isWindows ? RoutesManager.startRoute : RoutesManager.linkDeviceRoute,
            darkTheme: darkTheme,
            theme: theme,
          ),
        );
      },
    );
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {

  }
}
