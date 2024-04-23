import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:foe_archiving/core/helpers/extensions.dart';
import 'package:foe_archiving/presentation/shared/bloc/common_data_cubit.dart';

import '../../../core/localization/strings_manager.dart';
import '../../../core/theming/color_manager.dart';
import '../../../core/theming/font_manager.dart';
import '../../../core/theming/values_manager.dart';

Widget selectedActionDepartmentsWidget(BuildContext context, CommonDataCubit cubit){
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
        Text(AppStrings.requiredActionFromDepartments.tr(), style: TextStyle(color: Theme.of(context).primaryColorDark, fontFamily: FontConstants.family,fontSize: AppSize.s16,fontWeight: FontWeightManager.bold),overflow: TextOverflow.ellipsis),
        const SizedBox(height: AppSize.s4,),
        Flexible(
          child: ListView.builder(
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
                    Text('${cubit.selectedActionDepartmentsList[index]!.sectorName} - ${cubit.selectedActionDepartmentsList[index]!.departmentName}', style: TextStyle(color: Theme.of(context).primaryColorDark, fontFamily: FontConstants.family,fontSize: AppSize.s14,fontWeight: FontWeightManager.bold,overflow: TextOverflow.ellipsis),overflow: TextOverflow.ellipsis),
                    const Spacer(),
                    Icon(Icons.close_rounded, color: Theme.of(context).primaryColorDark, size: AppSize.s18,).ripple((){
                      cubit.removeFromAction(cubit.selectedActionDepartmentsList[index]!);
                    }, borderRadius: BorderRadius.circular(AppSize.s8),
                        overlayColor: MaterialStateColor.resolveWith((states) => Theme.of(context).primaryColorDark.withOpacity(AppSize.s0_2))),
                  ],
                ),
              );
            },
            itemCount: cubit.selectedActionDepartmentsList.length,
          ),
        ),
      ],
    ),
  );
}
Widget selectedKnowDepartmentsWidget(BuildContext context, CommonDataCubit cubit){
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
        Text(AppStrings.requiredKnowFromDepartments.tr(), style: TextStyle(color: Theme.of(context).primaryColorDark, fontFamily: FontConstants.family,fontSize: AppSize.s16,fontWeight: FontWeightManager.bold),overflow: TextOverflow.ellipsis),
        const SizedBox(height: AppSize.s4,),
        Flexible(
          child: ListView.builder(
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
                  children: [
                    Expanded(child: Text('${cubit.selectedKnowDepartmentsList[index].sectorName} - ${cubit.selectedKnowDepartmentsList[index].departmentName}', style: TextStyle(color: Theme.of(context).primaryColorDark, fontFamily: FontConstants.family,fontSize: AppSize.s14,fontWeight: FontWeightManager.bold, overflow: TextOverflow.ellipsis),overflow: TextOverflow.ellipsis,)),
                    Icon(Icons.close_rounded, color: Theme.of(context).primaryColorDark, size: AppSize.s18,).ripple((){
                      cubit.removeFromKnow(cubit.selectedKnowDepartmentsList[index]);
                    }, borderRadius: BorderRadius.circular(AppSize.s8),
                        overlayColor: MaterialStateColor.resolveWith((states) => Theme.of(context).primaryColorDark.withOpacity(AppSize.s0_2))),
                  ],
                ),
              );
            },
            itemCount: cubit.selectedKnowDepartmentsList.length,
          ),
        ),
      ],
    ),
  );
}
