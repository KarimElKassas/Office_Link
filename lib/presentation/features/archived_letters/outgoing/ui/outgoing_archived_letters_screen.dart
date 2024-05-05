import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foe_archiving/core/helpers/extensions.dart';
import 'package:foe_archiving/core/routing/routes.dart';
import 'package:foe_archiving/presentation/features/archived_letters/outgoing/ui/archived_letters_list.dart';
import 'package:foe_archiving/presentation/shared/bloc/common_data_cubit.dart';
import 'package:iconly/iconly.dart';

import '../../../../../core/di/service_locator.dart';
import '../../../../../core/helpers/functions/date_time_helpers.dart';
import '../../../../../core/localization/strings_manager.dart';
import '../../../../../core/theming/color_manager.dart';
import '../../../../../core/theming/font_manager.dart';
import '../../../../../core/theming/values_manager.dart';
import '../../../../../core/widgets/default_text_field.dart';
import '../../../../../data/models/letter_model.dart';
import '../../../income_letters/internal/bloc/income_internal_letters_cubit.dart';
import '../../../letter_details/helper/letter_details_args.dart';
import '../bloc/outgoing_archived_letters_cubit.dart';
import '../bloc/outgoing_archived_letters_states.dart';

class OutgoingArchivedLettersScreen extends StatelessWidget {
  const OutgoingArchivedLettersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<OutgoingArchivedLettersCubit>()..setupScrollController(context)..loadArchivedLetters(),
      child: BlocConsumer<OutgoingArchivedLettersCubit,OutgoingArchivedLettersStates>(
        listener: (context, state){},
        builder: (context, state){
          var cubit = OutgoingArchivedLettersCubit.get(context);
          return Scaffold(
            backgroundColor: Theme.of(context).primaryColorLight,
            body: FadeIn(
              duration: const Duration(milliseconds: 1500),
              child: Column(
                children: [
                  searchAndFilterWidget(context, cubit),
                  const SizedBox(height:  AppSize.s16,),
                  cubit.lettersList.isNotEmpty?
                  Expanded(
                    child: ArchivedOutgoingLettersListView(letterCubit: cubit,),
                  ):Expanded(
                      child: Center(
                        child: Text(AppStrings.noLettersExist.tr(),style: TextStyle(fontSize: AppSize.s22,fontFamily:FontConstants.family,color: Theme.of(context).primaryColorDark,fontWeight: FontWeight.bold),),
                      )
                  ),
                ],
              )
            ),
          );
        },
      ),
    );
  }
}

Widget searchAndFilterWidget(BuildContext context, OutgoingArchivedLettersCubit cubit){
  return Container(
    decoration: BoxDecoration(
        color: Colors.black12,
        border: Border.all(color: Colors.transparent,width: 0),
        borderRadius: BorderRadius.circular(AppSize.s16)
    ),
    margin: const EdgeInsets.all(AppSize.s8),
    padding: const EdgeInsets.all(AppSize.s12),
    child: Column(
      children: [
        SizedBox(
          height: 50,
          child: Row(
            children: [
              Expanded(
                child: registerTextField(
                  context: context,
                  controller: cubit.searchController,
                  background: Colors.transparent,
                  borderStyle: BorderStyle.none,
                  textInputType: TextInputType.text,
                  hintText: AppStrings.searchLetters.tr(),
                  textInputAction: TextInputAction.next,
                  suffixIcon: Icon(IconlyBroken.search, color: Theme.of(context).primaryColorDark,),
                  borderColor: Theme.of(context).primaryColorDark,
                  validate: (value) {},
                  onChanged: (String? value) {
                    cubit.searchLetters(value!);
                  },
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSize.s12,),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSize.s12),
          //child:
        ),

      ],
    ),
  );
}
Widget headerItem(BuildContext context, IncomeInternalLettersCubit cubit){
  return Padding(
    padding: const EdgeInsets.all(AppSize.s8),
    child: Material(
      color: Theme.of(context).splashColor,
      elevation: 5,
      borderRadius: const BorderRadius.all(Radius.circular(AppSize.s10)),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(AppSize.s10)),
            color: ColorManager.darkGoldColor.withOpacity(0.6)
        ),
        padding: const EdgeInsets.symmetric(horizontal: AppSize.s12, vertical: AppSize.s16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: Text(
                AppStrings.letterAbout.tr(),
                style: TextStyle(
                    color: Theme.of(context).primaryColorDark,
                    fontFamily: FontConstants.family,
                    fontSize: AppSize.s16,
                    fontWeight: FontWeightManager.bold),
              ),
            ),
            /*const SizedBox(width: AppSize.s32,),
            Expanded(
              child: Text(
                AppStrings.letterPrivateNumber.tr(),
                style: TextStyle(
                    color: Theme.of(context).primaryColorDark,
                    fontFamily: FontConstants.family,
                    fontSize: AppSize.s16,
                    fontWeight: FontWeightManager.bold),
              ),
            ),*/
            const SizedBox(width: AppSize.s24,),
            Expanded(
              child: Text(
                AppStrings.letterPaperNumber.tr(),
                style: TextStyle(
                    color: Theme.of(context).primaryColorDark,
                    fontFamily: FontConstants.family,
                    fontSize: AppSize.s16,
                    fontWeight: FontWeightManager.bold),
              ),
            ),
            const SizedBox(width: AppSize.s24,),
            Expanded(
              child: Text(
                AppStrings.letterDate.tr(),
                style: TextStyle(
                    color: Theme.of(context).primaryColorDark,
                    fontFamily: FontConstants.family,
                    fontSize: AppSize.s16,
                    fontWeight: FontWeightManager.bold),
              ),
            ),
            const SizedBox(width: AppSize.s24,),
            Expanded(
              child: Text(
                AppStrings.letterDirection.tr(),
                style: TextStyle(
                    color: Theme.of(context).primaryColorDark,
                    fontFamily: FontConstants.family,
                    fontSize: AppSize.s16,
                    fontWeight: FontWeightManager.bold),
              ),
            ),
            const SizedBox(width: AppSize.s24,),
            Expanded(
              child: Text(
                AppStrings.securityLevel.tr(),
                style: TextStyle(
                    color: Theme.of(context).primaryColorDark,
                    fontFamily: FontConstants.family,
                    fontSize: AppSize.s16,
                    fontWeight: FontWeightManager.bold),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
Widget letterItem(BuildContext context, LetterModel letterModel){
  return Padding(
    padding: const EdgeInsets.all(AppSize.s8),
    child: Material(
      color: Theme.of(context).splashColor,
      elevation: 5,
      borderRadius: const BorderRadius.all(Radius.circular(AppSize.s10)),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(AppSize.s10)),
            color: Theme.of(context).splashColor
        ),
        padding: const EdgeInsets.all(AppSize.s12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                letterModel.letterContent,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: Theme.of(context).primaryColorDark,
                    fontFamily: FontConstants.family,
                    fontSize: AppSize.s16,
                    fontWeight: FontWeightManager.bold),
              ),
            ),
            const SizedBox(width: AppSize.s32,),
            Expanded(
              child: Text(
                letterModel.letterNumber,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: Theme.of(context).primaryColorDark,
                    fontFamily: FontConstants.family,
                    fontSize: AppSize.s16,
                    fontWeight: FontWeightManager.bold),
              ),
            ),
            /*const SizedBox(width: AppSize.s24,),
            Expanded(
              child: Text(
                letterModel.letterNumber,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: Theme.of(context).primaryColorDark,
                    fontFamily: FontConstants.family,
                    fontSize: AppSize.s16,
                    fontWeight: FontWeightManager.bold),
              ),
            ),*/
            const SizedBox(width: AppSize.s24,),
            Expanded(
              child: Text(
                formatDate(letterModel.letterDate),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: Theme.of(context).primaryColorDark,
                    fontFamily: FontConstants.family,
                    fontSize: AppSize.s16,
                    fontWeight: FontWeightManager.bold),
              ),
            ),
            const SizedBox(width: AppSize.s24,),
            Expanded(
              child: Text(
                letterModel.departmentName.toString(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: Theme.of(context).primaryColorDark,
                    fontFamily: FontConstants.family,
                    fontSize: AppSize.s16,
                    fontWeight: FontWeightManager.bold),
              ),
            ),
            const SizedBox(width: AppSize.s24,),
            Expanded(
              child: Text(
                sl<CommonDataCubit>().getSecurityValueFromId(letterModel.confidentialityId),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: Theme.of(context).primaryColorDark,
                    fontFamily: FontConstants.family,
                    fontSize: AppSize.s16,
                    fontWeight: FontWeightManager.bold),
              ),
            ),
          ],
        ),
      ).ripple((){
        if(letterModel.internalDefaultLetterId != null){
          Navigator.pushNamed(
              context, Routes.letterDetailsRoute,
              arguments: LetterDetailsArgs(letterModel,false));
        }else if(letterModel.internalArchiveLetterId != null){
          Navigator.pushNamed(
              context, Routes.archivedLetterDetailsRoute,
              arguments: LetterDetailsArgs(letterModel,false));
        }

      },
          borderRadius: const BorderRadius.all(Radius.circular(AppSize.s10)),
          overlayColor: MaterialStateColor.resolveWith((states) => ColorManager.goldColor.withOpacity(0.15))),
    ),
  );
}
