import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foe_archiving/core/helpers/extensions.dart';
import 'package:foe_archiving/core/helpers/functions/date_time_helpers.dart';
import 'package:foe_archiving/presentation/shared/bloc/common_data_cubit.dart';
import 'package:foe_archiving/presentation/shared/bloc/common_data_states.dart';
import 'dart:ui' as ui;

import '../../../core/di/service_locator.dart';
import '../../../core/localization/strings_manager.dart';
import '../../../core/theming/color_manager.dart';
import '../../../core/theming/font_manager.dart';
import '../../../core/theming/values_manager.dart';
import '../../../core/utils/app_version.dart';
import '../../../core/widgets/default_text_field.dart';

Widget additionalInfoDialog(BuildContext context){
  bool isClosing = false;
  return BlocConsumer<CommonDataCubit,CommonDataStates>(
    listener: (context,state){},
    bloc: sl<CommonDataCubit>(),
    builder: (context,state){
      var cubit = sl<CommonDataCubit>();
      return Directionality(
        textDirection: ui.TextDirection.rtl,
        child: AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(AppSize.s8)),
          ),
            title: Row(
              children: [
                Icon(Icons.info_outline_rounded, color: ColorManager.goldColor, size: AppSize.s24,),
                const SizedBox(width: AppSize.s8,),
                Text(
                  AppStrings.additionalInformation.tr(),
                  style: TextStyle(
                      color: ColorManager.goldColor,
                      fontSize: AppSize.s20,
                      fontWeight: FontWeightManager.bold,
                      fontFamily: FontConstants.family),
                ),
              ],
            ),
            backgroundColor: Theme.of(context).splashColor,
            titlePadding: const EdgeInsets.only(top: AppSize.s12, left: AppSize.s12, right: AppSize.s12),
            contentPadding: const EdgeInsets.all(AppSize.s16),
            content: Builder(
              builder: (context) {
                var width = MediaQuery.sizeOf(context).width;
                return SizedBox(
                  width: width * 0.25,
                  child: ListView.builder(
                    physics: const ClampingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: cubit.additionalTypesList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return additionalItem(context, cubit, index);
                    },
                  ),
                );
              }
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () async {
                  cubit.logOut();
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

Widget additionalItem(BuildContext context,CommonDataCubit cubit, int index){
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSize.s8),
        child: Row(
          children: [
            Text(
              cubit.additionalTypesList[index].additionalInfoTitle,
              style: TextStyle(color: Theme.of(context).primaryColorDark,
                  fontFamily: FontConstants.family,
                  fontSize: AppSize.s16,
                  fontWeight: FontWeightManager.regular),
              maxLines: AppSize.s1.toInt(),
            ),
            const SizedBox(width: AppSize.s8,),
            Checkbox(
              value: cubit.additionalTypesList[index].isSelected,
              activeColor: Theme.of(context).primaryColorDark,
              checkColor: ColorManager.goldColor,
              onChanged: (bool? value) async {
                cubit.addOrRemoveAdditionalInfo(cubit.additionalTypesList[index].additionalInfoTypeId,
                    value!,DateTime.now());
              },
            ),
          ],
        ),
      ),
      if (cubit.additionalTypesList[index].isSelected)
        additionalValueWidget(context, cubit, index)
      else const SizedBox.shrink()
    ],
  );
}

Widget additionalValueWidget(BuildContext context, CommonDataCubit cubit, int index){
  if(cubit.additionalTypesList[index].valuePower == 2){
    return registerTextField(
      context: context,
      background: Colors.transparent,
      textInputType: TextInputType.text,
      hintText: AppStrings.writeHere.tr(),
      textInputAction: TextInputAction.done,
      borderColor: Theme.of(context).primaryColorDark,
      controller: cubit.getInfoController(cubit.additionalTypesList[index].additionalInfoTypeId),
      maxLines: 2,
      validate: (value) {
        if(value!.isEmpty){
          return AppStrings.letterNumber.tr();
        }
        if(value.length < 10){
          return AppStrings.lengthShorter.tr();
        }
      },
      onChanged: (String? value) {},
    );
  }else{
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSize.s6),
            border: Border.all(color: Theme.of(context).primaryColorDark.withOpacity(0.3)),
            color: Colors.transparent
        ),
        padding: const EdgeInsets.symmetric(
            horizontal: AppSize.s8,
            vertical: AppSize.s8),
        child: Text(
          formatDate(cubit.getAdditionalDateTime(cubit.additionalTypesList[index].additionalInfoTypeId).toString()),
          style: TextStyle(color: Theme.of(context).primaryColorDark,
              fontSize: AppSize.s16,
              fontFamily: FontConstants.family),
        )).ripple(() async {
      DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2010),
          lastDate: DateTime.now());
      if (pickedDate != null) {
        print("PICKED DATE : $pickedDate");
        cubit.updateDateInList(cubit.additionalTypesList[index].additionalInfoTypeId,pickedDate);
      }
    },
        borderRadius: const BorderRadius.all(Radius.circular(AppSize.s6)),
        overlayColor: MaterialStateColor.resolveWith((states) => Theme.of(context).primaryColorDark.withOpacity(0.15)));
  }
}

