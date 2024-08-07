import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foe_archiving/core/helpers/extensions.dart';
import 'package:foe_archiving/core/widgets/loading_indicator.dart';
import 'package:foe_archiving/presentation/features/files_and_contracts/all_files_and_contracts/bloc/all_file_and_contracts_states.dart';
import 'package:foe_archiving/presentation/features/files_and_contracts/all_files_and_contracts/bloc/all_files_and_contracts_cubit.dart';
import 'package:foe_archiving/presentation/features/outgoing_letters/internal/bloc/outgoing_internal_letters_cubit.dart';
import 'package:foe_archiving/presentation/features/outgoing_letters/internal/bloc/outgoing_internal_letters_states.dart';

import '../../../../../core/di/service_locator.dart';
import '../../../../../core/helpers/functions/date_time_helpers.dart';
import '../../../../../core/localization/strings_manager.dart';
import '../../../../../core/routing/routes.dart';
import '../../../../../core/theming/color_manager.dart';
import '../../../../../core/theming/font_manager.dart';
import '../../../../../core/theming/values_manager.dart';
import '../../../../../data/models/letter_model.dart';
import '../../../../shared/bloc/common_data_cubit.dart';
import '../../../letter_details/helper/letter_details_args.dart';

class AllFilesAndContractsListView extends StatelessWidget {
  final AllFilesAndContractsCubit contractsCubit; // Pass your LetterCubit instance

  const AllFilesAndContractsListView({
    Key? key,
    required this.contractsCubit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AllFilesAndContractsCubit, AllFilesAndContractsStates>(
      bloc: contractsCubit,
      builder: (context, state) {
        if(getListToUse(state).isEmpty){
          return Center(
            child: Text(AppStrings.noLettersExist.tr(),style: TextStyle(fontSize: AppSize.s22,fontFamily:FontConstants.family,color: Theme.of(context).primaryColorDark,fontWeight: FontWeight.bold),),
          );
        }

          else {
          return _buildListView(context,state);
        }
      },
    );
  }

  Widget headerItem(BuildContext context, AllFilesAndContractsCubit cubit){
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

  Widget _buildListView(BuildContext context, AllFilesAndContractsStates state) {
    return Column(
      children: [
        headerItem(context,contractsCubit),
        Expanded(
          child: ScrollbarTheme(
            data: ScrollbarThemeData(thickness: MaterialStateProperty.all(6)),
            child: Scrollbar(
              controller: contractsCubit.controller,
              trackVisibility: true,
              thumbVisibility: true,
              thickness: 4,
              child: ListView.builder(
                controller: contractsCubit.controller,
                shrinkWrap: true,
                key: key,
                itemCount: getListToUse(state).length + (state is OutgoingInternalLettersLoading ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index < getListToUse(state).length) {
                    final letter = getListToUse(state)[index];
                    // Customize the list item as per your requirement
                    return letterItem(context, letter);
                  } else if (state is OutgoingInternalLettersLoading){
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: loadingIndicator(), // Loading indicator at bottom of list
                      ),
                    );
                  }
                },
              )
            ),
          ),
        ),
      ],
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
          Navigator.pushNamed(
              context, Routes.contractDetailsRoute,
              arguments: LetterDetailsArgs(letterModel,false,allFilesAndContractsCubit: contractsCubit));

        },
            borderRadius: const BorderRadius.all(Radius.circular(AppSize.s10)),
            overlayColor: MaterialStateColor.resolveWith((states) => ColorManager.goldColor.withOpacity(0.15))),
      ),
    );
  }
}


List<LetterModel> getListToUse(AllFilesAndContractsStates state) {
  if (state is AllFilesAndContractsSuccess) {
    // If it's a success state, check if a search query is active
    if (state.lettersList.isNotEmpty) {
      return state.lettersList;
    } else {
      return [];
    }
  } else {
    return [];
  }
}

