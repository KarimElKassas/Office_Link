import 'package:flutter/material.dart';

import '../theming/color_manager.dart';
import '../theming/values_manager.dart';

Widget loadingIndicator(){
  return CircularProgressIndicator(color: ColorManager.goldColor, strokeWidth: AppSize.s0_8,);
}