import 'package:flutter/material.dart';
import 'package:foe_archiving/core/helpers/extensions.dart';
import '../../../core/theming/color_manager.dart';
import '../../../core/theming/font_manager.dart';
import '../../../core/theming/values_manager.dart';

Widget letterAddOnAction(BuildContext context,String label,IconData icon,Function onPressed){

  return Container(
    decoration: BoxDecoration(
      border: Border.all(color: ColorManager.goldColor.withOpacity(0.3)),
      borderRadius: const BorderRadius.all(
          Radius.circular(AppSize.s6)),
      color: Theme.of(context).splashColor.withOpacity(0.3),
      boxShadow: [
        BoxShadow(
          offset: const Offset(2, 3),
          blurRadius: 2,
          spreadRadius: 3,
          color: Colors.black12.withOpacity(0.2),
        ),
      ],
    ),
    constraints: const BoxConstraints(maxHeight: 100,minWidth: 100),
    padding: const EdgeInsets.symmetric(
        horizontal: AppSize.s8, vertical: AppSize.s8),
    child: Column(
      children: [
        Expanded(
          child: Icon(icon,
            color: ColorManager.goldColor.withOpacity(0.7), size: AppSize.s32,),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Text(
            label,
            style: TextStyle(color: Theme
                .of(context)
                .primaryColorDark,
                fontSize: AppSize.s14,
                fontFamily: FontConstants.family,
                fontWeight: FontWeight.w600),),
        )
      ],
    ),
  ).ripple((){
    onPressed();
  },
      borderRadius: const BorderRadius.all(Radius.circular(AppSize.s6)),
      overlayColor: MaterialStateColor.resolveWith((states) => ColorManager.goldColor.withOpacity(0.02)));
}