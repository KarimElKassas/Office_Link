import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foe_archiving/core/helpers/extensions.dart';
import 'package:foe_archiving/core/widgets/scale_dialog.dart';
import 'package:foe_archiving/presentation/shared/bloc/common_data_cubit.dart';
import 'package:foe_archiving/presentation/shared/bloc/common_data_states.dart';
import 'package:foe_archiving/presentation/shared/widgets/select_tags_component.dart';
import 'dart:ui' as ui;

import '../../../core/di/service_locator.dart';
import '../../../core/localization/strings_manager.dart';
import '../../../core/theming/color_manager.dart';
import '../../../core/theming/font_manager.dart';
import '../../../core/theming/values_manager.dart';
import '../../../core/widgets/default_text_field.dart';

Widget tagsDialog(BuildContext context) {
  bool isClosing = false;
  var cubit = sl<CommonDataCubit>();
  return BlocConsumer<CommonDataCubit, CommonDataStates>(
    bloc: cubit,
    listener: (context, state){},
    builder: (context, state){
      return Directionality(
        textDirection: ui.TextDirection.rtl,
        child: AlertDialog(
          // <-- SEE HERE
            title: Text(
              AppStrings.selectTags.tr(),
              style: TextStyle(
                  color: Theme.of(context).primaryColorDark,
                  fontSize: AppSize.s18,
                  fontWeight: FontWeightManager.bold,
                  fontFamily: FontConstants.family),
            ),
            backgroundColor: Theme.of(context).splashColor,
            titlePadding: const EdgeInsets.only(top: AppSize.s12, left: AppSize.s12, right: AppSize.s12),
            contentPadding: const EdgeInsets.all(AppSize.s12),
            content: SizedBox(
              width: MediaQuery.sizeOf(context).width / 3,
              child: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    SelectTagsComponent()
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: (){
                  scaleDialog(context, false, addTagDialog(context));
                },
                style: ButtonStyle(overlayColor: MaterialStateColor.resolveWith((states) => ColorManager.goldColor.withOpacity(0.4))),
                child: Text(
                  AppStrings.addNewTag.tr(),
                  style: TextStyle(
                      fontSize: AppSize.s14,
                      fontFamily: FontConstants.family,
                      fontWeight: FontWeightManager.heavy,
                      color: Theme.of(context).primaryColorDark),
                  maxLines: AppSize.s1.toInt(),
                ),
              ),
              TextButton(
                onPressed: () async {
                  if (!isClosing) {
                    isClosing = true;
                    Navigator.of(context).pop();
                  }
                },
                style: ButtonStyle(overlayColor: MaterialStateColor.resolveWith((states) => ColorManager.goldColor.withOpacity(0.4))),
                child: Text(
                  AppStrings.ok.tr(),
                  style: TextStyle(
                      fontSize: AppSize.s14,
                      fontFamily: FontConstants.family,
                      fontWeight: FontWeightManager.heavy,
                      color: Theme.of(context).primaryColorDark),
                  maxLines: AppSize.s1.toInt(),
                ),
              ),
            ],
            buttonPadding: const EdgeInsets.all(AppSize.s10)),
      );
    },
  );
}
Widget tagsWidget(BuildContext context, CommonDataCubit cubit){
  return Container(
    width: 350,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(AppSize.s6),
      color: Theme.of(context).splashColor,
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: AppSize.s8,),
        Text(AppStrings.tags.tr(), style: TextStyle(color: Theme.of(context).primaryColorDark, fontFamily: FontConstants.family,fontSize: AppSize.s16,fontWeight: FontWeightManager.bold),),
        const SizedBox(height: AppSize.s4,),
        ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index){
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSize.s6),
                color: ColorManager.goldColor.withOpacity(0.2),
              ),
              padding: const EdgeInsets.symmetric(horizontal: AppSize.s8, vertical: AppSize.s8),
              margin: const EdgeInsets.all(AppSize.s6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(cubit.selectedTagsList[index].tagName, style: TextStyle(color: Theme.of(context).primaryColorDark, fontFamily: FontConstants.family,fontSize: AppSize.s14,fontWeight: FontWeightManager.bold),),
                  const SizedBox(width: AppSize.s8,),
                  Icon(Icons.close_rounded, color: Theme.of(context).primaryColorDark, size: AppSize.s18,).ripple((){cubit.addOrRemoveTag(cubit.selectedTagsList[index]);}, borderRadius: BorderRadius.circular(AppSize.s8),
                      overlayColor: MaterialStateColor.resolveWith((states) => Theme.of(context).primaryColorDark.withOpacity(AppSize.s0_2))),
                ],
              ),
            );
          },
          itemCount: cubit.selectedTagsList.length,
        ),
      ],
    ),
  );
}
Widget addTagDialog(BuildContext context) {
  bool isClosing = false;
  return Directionality(
    textDirection: ui.TextDirection.rtl,
    child: AlertDialog(
      // <-- SEE HERE
        title: Text(AppStrings.addNewTag.tr(), style: TextStyle(color: Theme.of(context).primaryColorDark, fontFamily: FontConstants.family,fontSize: AppSize.s16,fontWeight: FontWeightManager.bold),),
        backgroundColor: Theme
            .of(context)
            .splashColor,
        titlePadding: const EdgeInsets.only(
            top: AppSize.s12, left: AppSize.s12, right: AppSize.s12),
        contentPadding: const EdgeInsets.all(AppSize.s12),
        content: registerTextField(
            controller: sl<CommonDataCubit>().addTagController,
            context: context,
            background: Colors.transparent,
            borderColor: Theme.of(context).primaryColorDark,
            textInputType: TextInputType.text,
            hintText: AppStrings.writeHere.tr(),
            textInputAction: TextInputAction.done,
            validate: (String? value){},
            onChanged: (String? value){}
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () async {
              sl<CommonDataCubit>().createTag().then((value){
                Navigator.of(context).pop();
              });
            },
            style: ButtonStyle(
                overlayColor: MaterialStateColor.resolveWith((states) => ColorManager.goldColor.withOpacity(0.4))),
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
            onPressed: () async {
              sl<CommonDataCubit>().addTagController.clear();
              Navigator.of(context).pop();
            },
            style: ButtonStyle(
                overlayColor: MaterialStateColor.resolveWith((states) => ColorManager.goldColor.withOpacity(0.4))),
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
