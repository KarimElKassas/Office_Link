import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foe_archiving/core/theming/styles_manager.dart';
import 'package:foe_archiving/core/theming/values_manager.dart';
import 'color_manager.dart';
import 'font_manager.dart';

class ThemeManager{
  getLightTheme(){
    return ThemeData(
        //main colors
        primaryColor: ColorManager.lightGreen,
        primaryColorDark: ColorManager.darkGreen, //icons
        primaryColorLight: ColorManager.white, // == dark second in dark mode
        backgroundColor: ColorManager.white,
        disabledColor: ColorManager.grey1,
        splashColor: ColorManager.grey2,
        unselectedWidgetColor: ColorManager.lightGreen,
        //cardView theme
        cardTheme: CardTheme(
            color: ColorManager.white,
            shadowColor: ColorManager.grey,
            elevation: AppSize.s4
        ),
        //app bar theme
        appBarTheme: AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: ColorManager.transparent,
            statusBarIconBrightness: Brightness.dark,
            // For Android (dark icons)
            statusBarBrightness: Brightness.light, // For iOS (dark icons)
          ),
          color: ColorManager.veryLightGreen,
          elevation: AppSize.s0,
          centerTitle: false,
          titleTextStyle: boldStyle(color: ColorManager.white, fontSize: FontSize.s16),
        ),
        //button theme
        buttonTheme: ButtonThemeData(
            shape: const StadiumBorder(),
            buttonColor: ColorManager.lightGreen,
            disabledColor: ColorManager.grey1,
            splashColor: ColorManager.veryLightGreen
        ),
        //elevated button theme
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            textStyle: regularStyle(color: ColorManager.white, fontSize: FontSize.s17), backgroundColor: ColorManager.lightGreen,
            elevation: AppSize.s4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSize.s12),
            ),
          ),
        ),
        //text theme
        textTheme: TextTheme(
          displayLarge: heavyStyle(color: ColorManager.darkGrey, fontSize: FontSize.s16),
          headlineMedium: heavyStyle(color: ColorManager.darkGrey, fontSize: FontSize.s14),
          headlineLarge: heavyStyle(color: ColorManager.darkGrey, fontSize: FontSize.s16),
          titleMedium: boldStyle(color: ColorManager.lightGreen, fontSize: FontSize.s16),
          bodyLarge: regularStyle(color: ColorManager.grey1),
          bodySmall: regularStyle(color: ColorManager.grey),
        ),
        //input decoration theme(text form field ...)
        inputDecorationTheme: InputDecorationTheme(
          //content padding
          contentPadding: const EdgeInsets.all(AppSize.s8),
          //hint style
          hintStyle: regularStyle(color: ColorManager.grey, fontSize: FontSize.s14),
          //label style
          labelStyle: boldStyle(color: ColorManager.grey, fontSize: FontSize.s14),
          //enabled border style
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: ColorManager.grey, width: AppSize.s1_5),
            borderRadius: const BorderRadius.all(Radius.circular(AppSize.s8)),),
          //focused border style
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: ColorManager.lightGreen, width: AppSize.s1_5),
            borderRadius: const BorderRadius.all(Radius.circular(AppSize.s8)),),
          //error border style
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: ColorManager.error, width: AppSize.s1_5),
            borderRadius: const BorderRadius.all(Radius.circular(AppSize.s8)),),
          //focused error border style
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: ColorManager.lightGreen, width: AppSize.s1_5),
            borderRadius: const BorderRadius.all(Radius.circular(AppSize.s8)),
          ),
        )
    );
  }

  getDarkTheme(){
    return ThemeData(
        //main colors
        primaryColor: ColorManager.darkColor,
        primaryColorDark: Colors.white.withOpacity(AppSize.s0_9), //icons and font
        primaryColorLight: ColorManager.darkColor, // backgrounds
        backgroundColor: ColorManager.darkColor,
        disabledColor: ColorManager.white54,
        splashColor: ColorManager.darkSecondColor,
        unselectedWidgetColor: ColorManager.white54,
        //cardView theme
        cardTheme: CardTheme(
            color: ColorManager.white,
            shadowColor: ColorManager.grey,
            elevation: AppSize.s4
        ),
        //app bar theme
        appBarTheme: AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: ColorManager.transparent,
            statusBarIconBrightness: Brightness.light,
            // For Android (dark icons)
            statusBarBrightness: Brightness.dark, // For iOS (dark icons)
          ),
          color: ColorManager.darkSecondColor,
          elevation: AppSize.s0,
          centerTitle: false,
          titleTextStyle: boldStyle(color: ColorManager.white, fontSize: FontSize.s16),
        ),
        //button theme
        buttonTheme: ButtonThemeData(
            shape: const StadiumBorder(),
            buttonColor: ColorManager.lightGreen,
            disabledColor: ColorManager.grey1,
            splashColor: ColorManager.veryLightGreen
        ),
        //elevated button theme
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            textStyle: regularStyle(color: ColorManager.white, fontSize: FontSize.s17), backgroundColor: ColorManager.lightGreen,
            elevation: AppSize.s4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSize.s12),
            ),
          ),
        ),
        //text theme
        textTheme: TextTheme(
          displayLarge: heavyStyle(color: ColorManager.white54, fontSize: FontSize.s16),
          headlineMedium: heavyStyle(color: ColorManager.white54, fontSize: FontSize.s12),
          headlineLarge: heavyStyle(color: ColorManager.white54, fontSize: FontSize.s14),
          titleMedium: boldStyle(color: ColorManager.lightGreen, fontSize: FontSize.s16),
          bodyLarge: regularStyle(color: ColorManager.grey1),
          bodySmall: regularStyle(color: ColorManager.grey),
        ),
        //input decoration theme(text form field ...)
        inputDecorationTheme: InputDecorationTheme(
          //content padding
          contentPadding: const EdgeInsets.all(AppSize.s8),
          //hint style
          hintStyle: regularStyle(color: ColorManager.grey, fontSize: FontSize.s14),
          //label style
          labelStyle: boldStyle(color: ColorManager.grey, fontSize: FontSize.s14),
          //enabled border style
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: ColorManager.grey, width: AppSize.s1_5),
            borderRadius: const BorderRadius.all(Radius.circular(AppSize.s8)),),
          //focused border style
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: ColorManager.lightGreen, width: AppSize.s1_5),
            borderRadius: const BorderRadius.all(Radius.circular(AppSize.s8)),),
          //error border style
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: ColorManager.error, width: AppSize.s1_5),
            borderRadius: const BorderRadius.all(Radius.circular(AppSize.s8)),),
          //focused error border style
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: ColorManager.lightGreen, width: AppSize.s1_5),
            borderRadius: const BorderRadius.all(Radius.circular(AppSize.s8)),
          ),
        )
    );
  }
}