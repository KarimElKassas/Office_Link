import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foe_archiving/core/widgets/default_text_field.dart';
import 'package:foe_archiving/core/widgets/loading_indicator.dart';
import 'package:foe_archiving/core/widgets/scale_dialog.dart';
import 'package:foe_archiving/core/widgets/show_toast.dart';
import 'package:foe_archiving/presentation/shared/bloc/common_data_cubit.dart';
import 'package:foe_archiving/presentation/shared/bloc/common_data_states.dart';
import 'package:foe_archiving/presentation/shared/widgets/sectors_component.dart';
import '../../../core/di/service_locator.dart';
import '../../../core/localization/strings_manager.dart';
import '../../../core/theming/color_manager.dart';
import '../../../core/theming/font_manager.dart';
import '../../../core/theming/values_manager.dart';
import 'dart:ui' as ui;

Widget departmentDialog(BuildContext context) {
  bool isClosing = false;
  return Directionality(
    textDirection: ui.TextDirection.rtl,
    child: AlertDialog(
      // <-- SEE HERE
        title: Text(AppStrings.addDepartments.tr(), style: TextStyle(color: Theme.of(context).primaryColorDark, fontFamily: FontConstants.family,fontSize: AppSize.s16,fontWeight: FontWeightManager.bold),),
        backgroundColor: Theme
            .of(context)
            .splashColor,
        titlePadding: const EdgeInsets.only(
            top: AppSize.s12, left: AppSize.s12, right: AppSize.s12),
        contentPadding: const EdgeInsets.all(AppSize.s12),
        content: sl<CommonDataCubit>().state is CommonDataLoading ? loadingIndicator(): departmentsWidget(context),
        actions: <Widget>[
          TextButton(
            onPressed: () async {
              if(sl<CommonDataCubit>().selectedSectorModel != null){
                scaleDialog(context, false, addDepartmentDialog(context));
              }else{
                showMToast(context, 'اختار القطاع اولاً', TextStyle(color: Theme.of(context).primaryColorDark,fontFamily: FontConstants.family,fontWeight: FontWeightManager.bold,fontSize: AppSize.s16), Colors.red);
              }
            },
            style: ButtonStyle(
                overlayColor: MaterialStateColor.resolveWith((states) => ColorManager.goldColor.withOpacity(0.4))),
            child: Text(
              AppStrings.addNewDepartment.tr(),
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
              sl<CommonDataCubit>().addAllDepartmentsToAction();
            },
            style: ButtonStyle(
                overlayColor: MaterialStateColor.resolveWith((states) => ColorManager.goldColor.withOpacity(0.4))),
            child: Text(
              AppStrings.selectAllAction.tr(),
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
              sl<CommonDataCubit>().addAllDepartmentsToKnow();
            },
            style: ButtonStyle(
                overlayColor: MaterialStateColor.resolveWith((states) => ColorManager.goldColor.withOpacity(0.4))),
            child: Text(
              AppStrings.selectAllKnow.tr(),
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
              if (!isClosing) {
                isClosing = true;
                Navigator.of(context).pop();
              }
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
        ],
        buttonPadding: const EdgeInsets.all(AppSize.s10)),
  );
}
Widget departmentsWidget(BuildContext context){
  return BlocConsumer<CommonDataCubit, CommonDataStates>(
    bloc: sl<CommonDataCubit>(),
    listener: (context, state){},
    builder: (context, state){
      var cubit = sl<CommonDataCubit>();
      return Container(
        width: MediaQuery.sizeOf(context).width * 0.4,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSize.s6),
          color: Theme.of(context).splashColor,
        ),
        padding: const EdgeInsets.all(AppSize.s8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: AppSize.s8,),
            SizedBox(height: AppSize.s40, child: GetSectorsComponent()),
            const SizedBox(height: AppSize.s8,),
            //cubit.selectedSectorModel != null ? headerItem(context, cubit) : const SizedBox.shrink(),
            cubit.departmentsList.isNotEmpty ? SizedBox(
              height: MediaQuery.sizeOf(context).height /  3,
              width: double.infinity,
              child: ListView.builder(
                controller: cubit.scrollController,
                physics: const ClampingScrollPhysics(),
                shrinkWrap: true,
                itemCount: cubit.departmentsList.length,
                itemBuilder: (BuildContext context, int index) {
                  return departmentItem(context, cubit, index);
                },
              ),
            ): const SizedBox.shrink()
          ],
        ),
      );
    },
  );
}
Widget departmentItem(BuildContext context, CommonDataCubit cubit, int index){
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: AppSize.s8),
    child: Material(
      color: Theme.of(context).splashColor,
      elevation: 5,
      borderRadius: const BorderRadius.all(Radius.circular(AppSize.s10)),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(AppSize.s10)),
            color: ColorManager.goldColor.withOpacity(0.2)
        ),
        padding: const EdgeInsets.symmetric(horizontal: AppSize.s12, vertical: AppSize.s6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 2,
              child: Text(
                cubit.departmentsList[index].departmentName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: Theme.of(context).primaryColorDark,
                    fontFamily: FontConstants.family,
                    fontSize: AppSize.s16,
                    fontWeight: FontWeightManager.bold),
              ),
            ),
            const SizedBox(width: AppSize.s8,),
            Row(
              children: [
                Transform.scale(
                  scale: 0.8,
                  child: Checkbox(
                    value: cubit.isDepartmentFoundAsAction(cubit.departmentsList[index]),
                    activeColor: Theme.of(context).primaryColorDark,
                    checkColor: ColorManager.goldColor,
                    onChanged: (bool? value) {
                      cubit.addDepartmentToAction(cubit.departmentsList[index]);
                    },
                  ),
                ),
                Text(
                  AppStrings.action.tr(),
                  style: TextStyle(
                      color: Theme.of(context).primaryColorDark,
                      fontFamily: FontConstants.family,
                      fontSize: AppSize.s16,
                      fontWeight: FontWeightManager.bold),
                ),
              ],
            ),
            const SizedBox(width: AppSize.s8,),
            Row(
              children: [
                Transform.scale(
                  scale: 0.8,
                  child: Checkbox(
                    value: cubit.isDepartmentFoundAsKnow(cubit.departmentsList[index]),
                    activeColor: Theme.of(context).primaryColorDark,
                    checkColor: ColorManager.goldColor,
                    onChanged: (bool? value) {
                      cubit.addDepartmentToKnow(cubit.departmentsList[index]);
                    },
                  ),
                ),
                Text(
                  AppStrings.know.tr(),
                  style: TextStyle(
                      color: Theme.of(context).primaryColorDark,
                      fontFamily: FontConstants.family,
                      fontSize: AppSize.s16,
                      fontWeight: FontWeightManager.bold),
                )
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
Widget addDepartmentDialog(BuildContext context) {
  bool isClosing = false;
  return Directionality(
    textDirection: ui.TextDirection.rtl,
    child: AlertDialog(
      // <-- SEE HERE
        title: Text(AppStrings.addNewDepartment.tr(), style: TextStyle(color: Theme.of(context).primaryColorDark, fontFamily: FontConstants.family,fontSize: AppSize.s16,fontWeight: FontWeightManager.bold),),
        backgroundColor: Theme
            .of(context)
            .splashColor,
        titlePadding: const EdgeInsets.only(
            top: AppSize.s12, left: AppSize.s12, right: AppSize.s12),
        contentPadding: const EdgeInsets.all(AppSize.s12),
        content: registerTextField(
            controller: sl<CommonDataCubit>().addDepartmentController,
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
              sl<CommonDataCubit>().createDepartment().then((value){
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
              sl<CommonDataCubit>().addDepartmentController.clear();
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
