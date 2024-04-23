import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:foe_archiving/core/theming/values_manager.dart';

class BlurryProgressDialog extends StatelessWidget {
  final String title;
  TextStyle? titleStyle;
  double? titleMinSize, titleMaxSize, blurValue;
  int? titleMaxLines;

  BlurryProgressDialog(
      {Key? key,
        required this.title,
        this.titleStyle,
        this.titleMaxLines,
        this.titleMaxSize,
        this.titleMinSize,
        this.blurValue})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blurValue ?? 4, sigmaY: blurValue ?? 4),
          child: AlertDialog(
            backgroundColor: Theme.of(context).splashColor,
            scrollable: true,
            content: Column(
              children: [
                CircularProgressIndicator(
                  color: Theme.of(context).primaryColorDark,
                  strokeWidth: AppSize.s0_8,
                ),
                const SizedBox(
                  height: AppSize.s36,
                ),
                Text(
                  title,
                  style: titleStyle ??
                      TextStyle(
                        color: Theme.of(context).primaryColorDark,
                        fontSize: AppSize.s12,),
                  maxLines: titleMaxLines ?? AppSize.s2.toInt(),
                ),
                const SizedBox(
                  height: AppSize.s8,
                ),
              ],
            ),
          )),
    );
  }
}