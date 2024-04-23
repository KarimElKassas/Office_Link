import 'package:flutter/material.dart';
import 'package:foe_archiving/core/theming/values_manager.dart';

Widget defaultButton({
  double? width,
  double height = AppSize.s50,
  Color background = const Color(0xffE3BC41),
  Color textColor = Colors.white,
  Color borderColor = Colors.white,
  TextStyle? textStyle,
  double radius = AppSize.s8,
  bool isUpperCase = false,
  bool outline = false,
  EdgeInsets? padding,
  required VoidCallback function,
  required String text,
}) =>
    Container(
      padding: padding??EdgeInsets.zero,
      width: width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(radius)),
          color: outline ? Colors.transparent : background,
          border: Border.all(
            color: borderColor,
            width: AppSize.s0_8,
          )),
      child: MaterialButton(
        onPressed: function,
        height: height,
        child: Text(
          isUpperCase ? text.toUpperCase() : text,
          textAlign: TextAlign.center,
          style: textStyle ??
              TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  letterSpacing: 2,
                  color: textColor),
        ),
      ),
    );
