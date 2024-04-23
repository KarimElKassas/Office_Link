
import 'package:flutter/material.dart';
import 'package:foe_archiving/core/helpers/extensions.dart';
import 'package:foe_archiving/core/theming/values_manager.dart';
import 'package:foe_archiving/presentation/shared/bloc/common_data_cubit.dart';

import '../../../../../core/theming/color_manager.dart';
import '../../../../../core/theming/font_manager.dart';

Widget sideMenuItem(BuildContext context, CommonDataCubit cubit,
    int pageNumber, String label, IconData icon, Function onPressed,
    {bool hasBadge = false}) {
  return Container(
    height: AppSize.s40,
    decoration: cubit.selectedMenuBox == pageNumber
        ? BoxDecoration(
      color: ColorManager.goldColor.withOpacity(0.15),
      borderRadius: const BorderRadius.only(
          topRight: Radius.circular(AppSize.s24),
          bottomRight: Radius.circular(AppSize.s24)),
    )
        : const BoxDecoration(color: Colors.transparent),
    margin: const EdgeInsets.only(top: AppSize.s12, right: AppSize.s12),
    padding: const EdgeInsets.only(
      right: AppSize.s12,
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: AppSize.s20,
          color: cubit.selectedMenuBox == pageNumber
              ? ColorManager.goldColor
              : Theme
              .of(context)
              .primaryColorDark,
        ),
        const SizedBox(
          width: AppSize.s12,
        ),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
                color: Theme
                    .of(context)
                    .primaryColorDark,
                fontSize: AppSize.s16,
                fontFamily: FontConstants.family,
                fontWeight: FontWeightManager.bold),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: AppSize.s6,),
        (hasBadge && cubit.unReadNotificationsCount != 0) ? Row(
          children: [
            Container(
              height: 30,
              width: 30,
              decoration:  BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.red.withOpacity(0.8),
              ),
              child: Center(
                child: Text(
                  cubit.unReadNotificationsCount.toString(),
                  style: TextStyle(
                      color: Theme.of(context).primaryColorDark,
                      fontSize: AppSize.s14,
                      fontWeight: FontWeightManager.bold),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            const SizedBox(width: AppSize.s6,),
          ],
        ) : const SizedBox.shrink(),
        Container(
          decoration: BoxDecoration(
              color: cubit.selectedMenuBox == pageNumber
                  ? ColorManager.goldColor
                  : Colors.transparent,
              borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(AppSize.s4),
                  bottomRight: Radius.circular(AppSize.s4))),
          width: AppSize.s4,
          height: AppSize.s40,
        ),
      ],
    ),
  ).ripple(() {
    onPressed();
  },
      paddingTop: AppSize.s12,
      paddingRight: AppSize.s12,
      borderRadius: const BorderRadius.only(
          topRight: Radius.circular(AppSize.s24),
          bottomRight: Radius.circular(AppSize.s24)),
      overlayColor: MaterialStateColor.resolveWith((states) => ColorManager.goldColor.withOpacity(0.1)));
}
