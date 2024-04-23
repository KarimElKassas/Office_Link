import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theming/color_manager.dart';
import '../theming/font_manager.dart';
import '../theming/values_manager.dart';
Widget registerTextField(
    {required BuildContext context,
      required TextInputType textInputType,
      required String hintText,
      required TextInputAction textInputAction,
      required Function(String? value) validate,
      required Function(String? value) onChanged,
      List<TextInputFormatter>? inputFormatter,
      FocusNode? focusNode,
      TextStyle? textStyle,
      TextStyle? hintStyle,
      String? labelText,
      Widget? suffixIcon,
      Widget? prefixIcon,
      bool? isPassword,
      bool showLabel = false,
      Color? background,
      Color? borderColor,
      Color? cursorColor,
      BorderStyle? borderStyle,
      EdgeInsetsGeometry? contentPadding,
      double? borderRadius,
      int? maxLines,
      bool? readOnly,
      TextEditingController? controller}) {
  return TextFormField(
    controller: controller,
    focusNode: focusNode,
    inputFormatters: inputFormatter,
    cursorWidth: AppSize.s1,
    maxLines: maxLines ?? 1,
    cursorColor: cursorColor ?? Theme.of(context).primaryColorDark.withOpacity(AppSize.s0_8),
    textDirection: TextDirection.rtl,
    keyboardType: textInputType,
    textInputAction: textInputAction,
    readOnly: readOnly ?? false,
    obscureText: isPassword ?? false,
    textAlignVertical: TextAlignVertical.center,
    textAlign: TextAlign.start, //Constants.currentLocale == LanguageType.ARABIC.getValue() ? ,
    validator: (value) => validate(value),
    onChanged: (value) => onChanged(value),
    decoration: InputDecoration(
        filled: true,
        fillColor: background ?? ColorManager.white.withOpacity(AppSize.s0_8),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(borderRadius ?? AppSize.s8)),
          borderSide: BorderSide(
              width: AppSize.s0_2,
              style: borderStyle ?? BorderStyle.solid,
              color: borderColor ?? Theme.of(context).primaryColorDark),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius:
          BorderRadius.all(Radius.circular(borderRadius ?? AppSize.s8)),
          borderSide: BorderSide(
            width: AppSize.s0_2,
            style: borderStyle ?? BorderStyle.solid,
            color: ColorManager.goldColor,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius:
          BorderRadius.all(Radius.circular(borderRadius ?? AppSize.s8)),
          borderSide: BorderSide(
              width: AppSize.s0_2,
              style: borderStyle ?? BorderStyle.solid,
              color: ColorManager.goldColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius:
          BorderRadius.all(Radius.circular(borderRadius ?? AppSize.s8)),
          borderSide: BorderSide(
              width: AppSize.s0_2,
              style: borderStyle ?? BorderStyle.solid,
              color: borderColor ?? Theme.of(context).primaryColorDark),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius:
          BorderRadius.all(Radius.circular(borderRadius ?? AppSize.s8)),
          borderSide: BorderSide(
              width: AppSize.s0_2,
              style: borderStyle ?? BorderStyle.solid,
              color: borderColor ?? Theme.of(context).primaryColorDark),
        ),
        labelText: showLabel ? labelText : hintText,
        labelStyle: hintStyle ?? TextStyle(
            fontSize: AppSize.s14,
            backgroundColor: Colors.transparent,
            color: Theme.of(context).primaryColorDark.withOpacity(AppSize.s0_8),
            fontFamily: FontConstants.family,
            fontWeight: FontWeightManager.bold),
        floatingLabelStyle: TextStyle(fontSize: AppSize.s14, color: Theme.of(context).primaryColorDark),
        hintText: hintText,
        hintStyle: hintStyle ?? TextStyle(
            fontSize: AppSize.s14,
            backgroundColor: Colors.transparent,
            color: Theme.of(context).primaryColorDark.withOpacity(AppSize.s0_8),
            fontFamily: FontConstants.family,
            fontWeight: FontWeightManager.bold),
        //alignLabelWithHint: true,
        errorStyle: TextStyle(
            fontSize: AppSize.s12,
            color: ColorManager.goldColor,
            fontFamily: FontConstants.family,
            fontWeight: FontWeightManager.bold),
        floatingLabelBehavior: showLabel ? FloatingLabelBehavior.always : FloatingLabelBehavior.never,

        hintTextDirection: TextDirection.rtl,
        border: OutlineInputBorder(
            borderSide: BorderSide(
              width: AppSize.s0_2,
              color: borderColor ?? Theme.of(context).primaryColorDark,
              style: BorderStyle.none,
            ),
            borderRadius: BorderRadius.all(
                Radius.circular(borderRadius ?? AppSize.s8))),
        prefixIcon: prefixIcon,
        contentPadding: contentPadding ?? const EdgeInsets.symmetric(horizontal: AppSize.s12),
        suffixIcon: suffixIcon,
        errorMaxLines: 2),
    style: textStyle ??
        TextStyle(
            fontSize: AppSize.s14,
            color: Theme.of(context).primaryColorDark.withOpacity(AppSize.s0_8),
            fontFamily: FontConstants.family,
            fontWeight: FontWeightManager.bold),
  );
}