
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foe_archiving/core/helpers/extensions.dart';
import 'package:foe_archiving/core/routing/routes.dart';
import 'package:foe_archiving/presentation/shared/bloc/common_data_cubit.dart';
import 'package:foe_archiving/presentation/shared/bloc/common_data_states.dart';
import 'package:iconly/iconly.dart';
import 'dart:ui' as ui;
import '../../../../../core/localization/strings_manager.dart';
import '../../../../../core/theming/color_manager.dart';
import '../../../../../core/theming/font_manager.dart';
import '../../../../../core/theming/values_manager.dart';
import '../../../core/di/service_locator.dart';
import '../../../core/widgets/default_text_field.dart';

Widget changePasswordDialog(BuildContext context) {
  bool isClosing = false;

  return BlocConsumer<CommonDataCubit,CommonDataStates>(
    bloc: sl<CommonDataCubit>(),
    listener: (context, state){},
    builder: (context, state){
      var cubit = sl<CommonDataCubit>();
      return Directionality(
        textDirection: ui.TextDirection.rtl,
        child: AlertDialog(
          // <-- SEE HERE
            title: Text(
              AppStrings.changePassword.tr(),
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
                  SizedBox(
                    height: 50,
                    child: Row(
                      children: [
                        Expanded(
                          child: registerTextField(
                            context: context,
                            background: Colors.transparent,
                            textInputType: TextInputType.visiblePassword,
                            hintText: AppStrings.userPassword.tr(),
                            textInputAction: TextInputAction.done,
                            suffixIcon: Icon(IconlyBold.password, color: Theme.of(context).primaryColorDark.withOpacity(AppSize.s0_8),),
                            controller: cubit.newPasswordController,
                            validate: (value) {
                              if(value!.isEmpty) {
                                return AppStrings.userPasswordRequired.tr();
                              }
                            },
                            prefixIcon: InkWell(
                              onTap: (){
                                cubit.changePasswordVisibility();
                              },
                              child: Icon(cubit.isPassword ? Icons.visibility_rounded : Icons.visibility_off_rounded, color: Theme.of(context).primaryColorDark.withOpacity(AppSize.s0_8),),
                            ),
                            isPassword: cubit.isPassword, onChanged: (String? value) {},
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () async {
                  cubit.changePassword();
                  if (!isClosing) {
                    isClosing = true;
                    Navigator.of(context).pop();
                  }
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
    },
  );
}
