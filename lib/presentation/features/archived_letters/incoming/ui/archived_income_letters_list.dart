import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foe_archiving/core/helpers/extensions.dart';
import 'package:foe_archiving/core/widgets/loading_indicator.dart';
import 'package:foe_archiving/presentation/features/archived_letters/incoming/bloc/incoming_archived_letters_states.dart';
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
import '../bloc/incoming_archived_letters_cubit.dart';

class ArchivedIncomeLettersListView extends StatelessWidget {
  final IncomingArchivedLettersCubit letterCubit; // Pass your LetterCubit instance

  const ArchivedIncomeLettersListView({
    Key? key,
    required this.letterCubit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IncomingArchivedLettersCubit, IncomingArchivedLettersStates>(
      bloc: letterCubit,
      builder: (context, state) {
        return _buildListView(context,state);
      },
    );
  }

  Widget headerItem(BuildContext context, IncomingArchivedLettersCubit cubit){
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
                  AppStrings.letterDirectionOrDepartment.tr(),
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

  Widget _buildListView(BuildContext context, IncomingArchivedLettersStates state) {
    return Column(
      children: [
        getListToUse(letterCubit, state).isNotEmpty ? headerItem(context,letterCubit) : const SizedBox.shrink(),
        Expanded(
          child: ScrollbarTheme(
            data: ScrollbarThemeData(thickness: MaterialStateProperty.all(6)),
            child: Scrollbar(
              controller: letterCubit.controller,
              trackVisibility: true,
              thumbVisibility: true,
              thickness: 4,
              child: ListView.builder(
                controller: letterCubit.controller,
                shrinkWrap: true,
                key: key,
                itemCount: getListToUse(letterCubit, state).length + (state is IncomingArchivedLettersLoading ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index < getListToUse(letterCubit, state).length) {
                    final letter = getListToUse(letterCubit, state)[index];
                    // Customize the list item as per your requirement
                    return letterItem(context, letter);
                  } else if (state is IncomingArchivedLettersLoading){
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: loadingIndicator(), // Loading indicator at bottom of list
                      ),
                    );
                  }
                },
              ),
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
          print("ID : ${letterModel.internalArchiveLetterId}");
          Navigator.pushNamed(
              context, Routes.archivedLetterDetailsRoute,
              arguments: LetterDetailsArgs(letterModel,false,incomingArchivedLettersCubit: letterCubit));

        },
            borderRadius: const BorderRadius.all(Radius.circular(AppSize.s10)),
            overlayColor: MaterialStateColor.resolveWith((states) => ColorManager.goldColor.withOpacity(0.15))),
      ),
    );
  }

}

List<LetterModel> getListToUse(IncomingArchivedLettersCubit cubit, IncomingArchivedLettersStates state) {
  if (state is IncomingArchivedLettersSuccess) {
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
