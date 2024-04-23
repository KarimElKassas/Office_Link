import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theming/values_manager.dart';
AppBar appBar({
  Color? statusBarColor,
  Color? backgroundColor,
  Brightness? statusBarIconBrightness,
  Brightness? statusBarBrightness,
  double? toolBarHeight,
  double? elevation,
  Widget? flexibleSpace
}) {
  return AppBar(
    automaticallyImplyLeading: false,
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: statusBarColor,
      statusBarIconBrightness: statusBarIconBrightness,
      // For Android (dark icons)
      statusBarBrightness: statusBarBrightness, // For iOS (dark icons)
    ),
    toolbarHeight: toolBarHeight,
    elevation: elevation ?? AppSize.s0,
    backgroundColor: backgroundColor,
    flexibleSpace: flexibleSpace,
  );
}