import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foe_archiving/core/theming/color_manager.dart';
import 'package:foe_archiving/core/widgets/show_toast.dart';
import 'package:foe_archiving/presentation/features/archived_letters/all_archived/ui/all_archived_letters_screen.dart';
import 'package:foe_archiving/presentation/features/files_and_contracts/all_files_and_contracts/ui/all_files_and_contracts_screen.dart';
import 'package:foe_archiving/presentation/features/income_letters/external/ui/income_external_letters_screen.dart';
import 'package:foe_archiving/presentation/features/new_letter/ui/new_letter_screen.dart';
import 'package:foe_archiving/presentation/features/outgoing_letters/external/ui/outgoing_external_letters_screen.dart';
import 'package:foe_archiving/presentation/shared/bloc/common_data_cubit.dart';
import 'package:foe_archiving/presentation/shared/bloc/common_data_states.dart';
import 'package:foe_archiving/presentation/shared/widgets/change_password_dialog.dart';

import '../../../core/di/service_locator.dart';
import '../../../core/localization/strings_manager.dart';
import '../../../core/theming/font_manager.dart';
import '../../../core/theming/values_manager.dart';
import '../../../core/widgets/scale_dialog.dart';
import '../../features/files_and_contracts/new_file_and_contract/ui/new_file_and_contract_screen.dart';
import '../../features/income_letters/internal/ui/income_internal_letters_screen.dart';
import '../../features/outgoing_letters/internal/ui/outgoing_internal_letters_screen.dart';
import '../../resources/asset_manager.dart';
import '../widgets/exit_dialog.dart';
import '../widgets/side_menu_item.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<CommonDataCubit>()..getDepartmentById()..getAllSectors()..getAllTags()
        ..getAllDirections()..getAllAdditionalTypes()..sortAdditionalList(),
      child: BlocConsumer<CommonDataCubit,CommonDataStates>(
        listener: (context, state){
          if(state is CommonDataSuccessChangePassword){
            showMToast(
                context,
                AppStrings.passwordChangedSuccessfully.tr(),
                TextStyle(
                    color: Theme.of(context).primaryColorDark,
                    fontFamily: FontConstants.family,
                    fontSize: AppSize.s16),
                ColorManager.goldColor.withOpacity(0.3));
          }
        },
        builder: (context, state){
          var cubit = CommonDataCubit.get(context);
          return Scaffold(
            backgroundColor: Theme.of(context).primaryColorLight,
            body: FadeIn(
              duration: const Duration(seconds: 2),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    color: Theme.of(context).splashColor,
                    height: MediaQuery.sizeOf(context).height,
                    width: 250,
                    padding: const EdgeInsets.symmetric(vertical: AppSize.s16),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Image.asset(
                          height: 100,
                          width: MediaQuery.sizeOf(context).width / 2,
                          ImageAsset.registerLogo,
                          alignment: Alignment.center,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: AppSize.s16, horizontal: AppSize.s8),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              cubit.myDepartment,
                              style: TextStyle(
                                  color: Theme.of(context).primaryColorDark,
                                  fontSize: AppSize.s16,
                                  fontFamily: FontConstants.family,
                                  fontWeight: FontWeightManager.bold),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(bottom: AppSize.s24, top: AppSize.s16),
                          color: Theme
                              .of(context)
                              .primaryColorDark
                              .withOpacity(AppSize.s0_6),
                          width: AppSize.sFullWidth,
                          height: AppSize.s1,
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children:
                                !cubit.isSecretary() ? sideMenuItems(context, cubit) : secretarySideMenuItems(context, cubit),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: sideMenuItem(
                              context, cubit, !cubit.isSecretary() ? 6 : 8, AppStrings.changePassword.tr(),
                              Icons.security_outlined, () {
                            scaleDialog(context, true, changePasswordDialog(context));
                          }),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: sideMenuItem(
                              context, cubit, !cubit.isSecretary() ? 7 : 9, AppStrings.logout.tr(),
                              Icons.logout_outlined, () {
                            scaleDialog(context, true, alterExitDialog(context, cubit));
                          }),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: cubit.isSecretary() ? secretaryPagesWidget(context, cubit)
                        : normalPagesWidget(context, cubit),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
Widget normalPagesWidget(BuildContext context,CommonDataCubit cubit){
  return PageView(
    controller: cubit.elPageController,
    children: [
      NewLetterScreen(),
      NewFileAndContractScreen(),
      const IncomeInternalLettersScreen(),
      const OutgoingInternalLettersScreen(),
      const AllFilesAndContractsScreen(),
      const AllArchivedLettersScreen(),
      //NotificationsScreen(),
      //NewLetterScreen(),
      /*NewArchivedLetterScreen(),
      const IncomingLettersScreen(),
      const OutgoingLettersScreen(),
      const ArchivedLettersScreen(),
      const LocalLettersScreen(),*/
    ],
  );
}
Widget secretaryPagesWidget(BuildContext context,CommonDataCubit cubit){
  return PageView(
    controller: cubit.elPageController,
    children: [
      NewLetterScreen(),
      NewFileAndContractScreen(),
      const IncomeInternalLettersScreen(),
      const IncomeExternalLettersScreen(),
      const OutgoingInternalLettersScreen(),
      const OutgoingExternalLettersScreen(),
      const AllFilesAndContractsScreen(),
      const AllArchivedLettersScreen(),
      //NotificationsScreen(),
      //NewLetterScreen(),
      /*NewArchivedLetterScreen(),
      const IncomingLettersScreen(),
      const OutgoingLettersScreen(),
      const ArchivedLettersScreen(),
      const LocalLettersScreen(),*/
    ],
  );
}
List<Widget> sideMenuItems(BuildContext context, CommonDataCubit cubit){
  return [
    sideMenuItem(context, cubit, 0,
        AppStrings.addNewLetter.tr(),
        Icons.new_label_outlined, () {
          cubit.changeSelectedBox(0);
        }),
    sideMenuItem(context, cubit, 1,
        AppStrings.addFilesAndContracts.tr(),
        Icons.attach_file_rounded, () {
          cubit.changeSelectedBox(1);
        }),
    sideMenuItem(context, cubit, 2,
        AppStrings.income.tr(),
        Icons.call_missed_outgoing_outlined, () {
          cubit.changeSelectedBox(2);
        }),
    sideMenuItem(context, cubit, 3,
        AppStrings.outgoing.tr(),
        Icons.call_missed_outlined, () {
          cubit.changeSelectedBox(3);
        }),
    sideMenuItem(context, cubit, 4,
        AppStrings.filesAndContracts.tr(),
        Icons.file_copy_outlined, () {
          cubit.changeSelectedBox(4);
        }),
    sideMenuItem(context, cubit, 5,
        AppStrings.archivedLetters.tr(),
        Icons.archive_outlined, () {
          cubit.changeSelectedBox(5);
        }),
  ];
}
List<Widget> secretarySideMenuItems(BuildContext context, CommonDataCubit cubit){
  return [
    sideMenuItem(context, cubit, 0,
        AppStrings.addNewLetter.tr(),
        Icons.new_label_outlined, () {
          cubit.changeSelectedBox(0);
        }),
    sideMenuItem(context, cubit, 1,
        AppStrings.addFilesAndContracts.tr(),
        Icons.attach_file_rounded, () {
          cubit.changeSelectedBox(1);
        }),
    sideMenuItem(context, cubit, 2,
        AppStrings.incomeInternalLetters.tr(),
        Icons.call_missed_outgoing_outlined, () {
          cubit.changeSelectedBox(2);
        }),
    sideMenuItem(context, cubit, 3,
        AppStrings.incomeExternalLetters.tr(),
        Icons.call_missed_outgoing_outlined, () {
          cubit.changeSelectedBox(3);
        }),
    sideMenuItem(context, cubit, 4,
        AppStrings.outgoingInternalLetters.tr(),
        Icons.call_missed_outlined, () {
          cubit.changeSelectedBox(4);
        }),
    sideMenuItem(context, cubit, 5,
        AppStrings.outgoingExternalLetters.tr(),
        Icons.call_missed_outlined, () {
          cubit.changeSelectedBox(5);
        }),
    sideMenuItem(context, cubit, 6,
        AppStrings.filesAndContracts.tr(),
        Icons.file_copy_outlined, () {
          cubit.changeSelectedBox(6);
        }),
    sideMenuItem(context, cubit, 7,
        AppStrings.archivedLetters.tr(),
        Icons.archive_outlined, () {
          cubit.changeSelectedBox(7);
        }),
  ];
}