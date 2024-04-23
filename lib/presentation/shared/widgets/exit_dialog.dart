
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:foe_archiving/core/helpers/extensions.dart';
import 'package:foe_archiving/core/routing/routes.dart';
import 'package:foe_archiving/presentation/shared/bloc/common_data_cubit.dart';
import 'dart:ui' as ui;
import '../../../../../core/localization/strings_manager.dart';
import '../../../../../core/theming/color_manager.dart';
import '../../../../../core/theming/font_manager.dart';
import '../../../../../core/theming/values_manager.dart';
import '../../../core/di/service_locator.dart';

Widget alterExitDialog(BuildContext context, CommonDataCubit cubit) {
  bool isClosing = false;

  return Directionality(
    textDirection: ui.TextDirection.rtl,
    child: AlertDialog(
      // <-- SEE HERE
        title: Text(
          AppStrings.warning.tr(),
          style: TextStyle(
              color: Theme
                  .of(context)
                  .primaryColorDark,
              fontSize: AppSize.s16,
              fontWeight: FontWeightManager.bold,
              fontFamily: FontConstants.family),
        ),
        backgroundColor: Theme
            .of(context)
            .splashColor,
        titlePadding: const EdgeInsets.only(
            top: AppSize.s12, left: AppSize.s12, right: AppSize.s12),
        contentPadding: const EdgeInsets.all(AppSize.s12),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(
                AppStrings.areYouSureExit.tr(),
                style: TextStyle(
                    color: Theme
                        .of(context)
                        .primaryColorDark,
                    fontSize: AppSize.s14,
                    fontWeight: FontWeightManager.bold,
                    fontFamily: FontConstants.family),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () async {
              cubit.logOut();
              //context.pushReplacementNamed(Routes.loginRoute);
              cubit.close();
              sl.resetLazySingleton<CommonDataCubit>();
              Navigator.pushNamedAndRemoveUntil(
                context,
                Routes.loginRoute,
                    (route) => false,
              );
            },
            style: ButtonStyle(
                overlayColor: MaterialStateColor.resolveWith(
                        (states) => ColorManager.goldColor.withOpacity(0.4))),
            child: Text(
              AppStrings.ok.tr(),
              style: TextStyle(
                  fontSize: AppSize.s14,
                  fontFamily: FontConstants.family,
                  fontWeight: FontWeightManager.heavy,
                  color: Theme
                      .of(context)
                      .primaryColorDark),
              maxLines: AppSize.s1.toInt(),
            ),
          ),
          TextButton(
            onPressed: () {
              if (!isClosing) {
                isClosing = true;
                Navigator.of(context).pop();
              }
            },
            style: ButtonStyle(
                overlayColor: MaterialStateColor.resolveWith(
                        (states) => ColorManager.goldColor.withOpacity(0.4))),
            child: Text(
              AppStrings.cancel.tr(),
              style: TextStyle(
                  fontSize: AppSize.s14,
                  fontFamily: FontConstants.family,
                  fontWeight: FontWeightManager.heavy,
                  color: Theme
                      .of(context)
                      .primaryColorDark),
              maxLines: AppSize.s1.toInt(),
            ),
          ),
        ],
        buttonPadding: const EdgeInsets.all(AppSize.s10)),
  );
}
