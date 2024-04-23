import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:foe_archiving/core/helpers/extensions.dart';
import 'package:foe_archiving/core/utils/app_version.dart';
import 'package:foe_archiving/presentation/features/letter_reply/bloc/letter_reply_cubit.dart';
import 'package:foe_archiving/presentation/features/letter_reply/bloc/letter_reply_states.dart';
import 'package:foe_archiving/presentation/shared/bloc/common_data_cubit.dart';
import 'package:foe_archiving/presentation/shared/bloc/common_data_states.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/localization/strings_manager.dart';
import '../../../../core/theming/color_manager.dart';
import '../../../../core/theming/font_manager.dart';
import '../../../../core/theming/values_manager.dart';
import '../../../../core/widgets/default_button.dart';
import '../../../../core/widgets/default_text_field.dart';
import '../../../../core/widgets/scale_dialog.dart';
import '../../../../core/widgets/show_toast.dart';
import '../../../../data/models/letter_model.dart';
import '../../../shared/ui/pdf_thumbnail.dart';
import '../../../shared/widgets/additional_info_dialog.dart';
import '../../../shared/widgets/custom_thumbnail.dart';
import '../../../shared/widgets/department_widget.dart';
import '../../../shared/widgets/letter_add_on_widget.dart';
import '../../../shared/widgets/pdf_dialog.dart';
import '../../../shared/widgets/selected_action_department_component.dart';
import '../../../shared/widgets/tags_widget.dart';
import '../../files_and_contracts/new_file_and_contract/ui/new_file_and_contract_screen.dart';
import '../../letter_details/helper/letter_details_args.dart';
import '../../letter_details/ui/letter_details_screen.dart' as details;

class LetterReplyScreen extends StatelessWidget {
  LetterReplyScreen({Key? key, required this.letterModel}) : super(key: key);
  final LetterModel letterModel;
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => sl<LetterReplyCubit>(),
        child: BlocConsumer<LetterReplyCubit,LetterReplyStates>(
            listener: (context,state){
              if (state is LetterReplyLoadingSend) {
                SmartDialog.showLoading(backDismiss: true,clickMaskDismiss: true);
              }
              if (state is LetterReplySuccessSend) {
                SmartDialog.dismiss();
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                showMToast(
                    context,
                    AppStrings.letterSentSuccessful.tr(),
                    TextStyle(
                        color: Theme.of(context).primaryColorDark,
                        fontFamily: FontConstants.family,
                        fontSize: AppSize.s16),
                    ColorManager.goldColor.withOpacity(0.3));
              }
              if (state is LetterReplyErrorSend) {
                SmartDialog.dismiss();
                showMToast(
                    context,
                    state.error,
                    TextStyle(
                        color: Theme.of(context).primaryColorDark,
                        fontFamily: FontConstants.family,
                        fontSize: AppSize.s16),
                    ColorManager.goldColor.withOpacity(0.3));
              }
            },
            builder: (context,state){
              var cubit = LetterReplyCubit.get(context);
              return BlocConsumer<CommonDataCubit,CommonDataStates>(
                listener: (context,state){},
                bloc: sl<CommonDataCubit>(),
                builder: (context,state){
                  var commonDataCubit = sl<CommonDataCubit>();
                  return FadeIn(
                    duration: const Duration(milliseconds: 1500),
                    child: Form(
                      key: formKey,
                      child: Scaffold(
                        appBar: AppBar(
                          automaticallyImplyLeading: true,
                          iconTheme: IconThemeData(color: Theme.of(context).primaryColorDark),
                          title: Row(
                            children: [
                              Text(
                                  AppStrings.replyOnLetterWithNumber.tr(),
                                  style: TextStyle(color: Theme.of(context).primaryColorDark, fontSize: AppSize.s18,fontFamily: FontConstants.family,fontWeight: FontWeightManager.regular)
                              ),
                              MouseRegion(
                                cursor: MaterialStateMouseCursor.clickable,
                                onEnter: (_) => cubit.changeLetterNumberColor(Colors.blue),
                                onExit: (_) => cubit.changeLetterNumberColor(ColorManager.goldColor),
                                child: GestureDetector(
                                  onTap: () => scaleDialog(context, true, details.alterLetterDialog(context, [letterModel])),
                                  child: Text(
                                    letterModel.letterNumber,
                                    style: TextStyle(color: cubit.letterNumberColor, fontSize: AppSize.s18,fontFamily: FontConstants.family,fontWeight: FontWeightManager.bold, decoration: TextDecoration.underline),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        backgroundColor: Theme.of(context).primaryColorLight,
                        body: Padding(
                          padding: const EdgeInsets.all(AppSize.s16),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    letterAddOnAction(context, AppStrings.addDepartments.tr(), Icons.group_add_outlined, () {
                                      scaleDialog(context, true, departmentDialog(context));
                                    }),
                                    const SizedBox(width: AppSize.s16),
                                    letterAddOnAction(context, AppStrings.addTags.tr(),
                                        Icons.category_outlined, () {
                                          scaleDialog(context, true, tagsDialog(context));
                                        }),
                                    const SizedBox(
                                      width: AppSize.s16,
                                    ),
                                    letterAddOnAction(
                                        context,
                                        AppStrings.pickFiles.tr(),
                                        Icons.upload_file_outlined, () {
                                      commonDataCubit.pickFile();
                                    }),
                                    const SizedBox(
                                      width: AppSize.s16,
                                    ),
                                    letterAddOnAction(
                                        context,
                                        AppStrings.additionalInformation.tr(),
                                        Icons.add_circle_outline_sharp, () {
                                      scaleDialog(
                                          context, true, additionalInfoDialog(context));
                                    }),
                                  ],
                                ),
                                const SizedBox(
                                  height: AppSize.s16,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.circular(AppSize.s8),
                                    border: Border.all(
                                        color: Theme.of(context).primaryColorDark,
                                        width: AppSize.s0_2),
                                  ),
                                  padding: const EdgeInsets.all(AppSize.s12),
                                  child: Column(
                                    children: [
                                      Align(
                                        alignment: Alignment.topCenter,
                                        child: Text(
                                          AppStrings.securityLevel.tr(),
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColorDark,
                                              fontFamily: FontConstants.family,
                                              fontSize: AppSize.s16,
                                              fontWeight: FontWeightManager.bold),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: AppSize.s12,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                AppStrings.verySecure.tr(),
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .primaryColorDark,
                                                    fontFamily:
                                                    FontConstants.family,
                                                    fontSize: AppSize.s14,
                                                    fontWeight:
                                                    FontWeightManager.bold),
                                              ),
                                              const SizedBox(
                                                width: AppSize.s8,
                                              ),
                                              Checkbox(
                                                value: commonDataCubit
                                                    .securityLevel ==
                                                    Constants.topSecretGuid,
                                                activeColor: Theme.of(context)
                                                    .primaryColorDark,
                                                checkColor:
                                                ColorManager.goldColor,
                                                onChanged: (bool? value) async {
                                                  if (commonDataCubit
                                                      .securityLevel !=
                                                      Constants.topSecretGuid) {
                                                    commonDataCubit
                                                        .changeSecurityLevel(
                                                        Constants
                                                            .topSecretGuid);
                                                  }
                                                },
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                AppStrings.secure.tr(),
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .primaryColorDark,
                                                    fontFamily:
                                                    FontConstants.family,
                                                    fontSize: AppSize.s14,
                                                    fontWeight:
                                                    FontWeightManager.bold),
                                              ),
                                              const SizedBox(
                                                width: AppSize.s8,
                                              ),
                                              Checkbox(
                                                value: commonDataCubit
                                                    .securityLevel ==
                                                    Constants.secretGuid,
                                                activeColor: Theme.of(context)
                                                    .primaryColorDark,
                                                checkColor:
                                                ColorManager.goldColor,
                                                onChanged: (bool? value) async {
                                                  if (commonDataCubit
                                                      .securityLevel !=
                                                      Constants.secretGuid) {
                                                    commonDataCubit
                                                        .changeSecurityLevel(
                                                        Constants.secretGuid);
                                                  }
                                                },
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                AppStrings.normal.tr(),
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .primaryColorDark,
                                                    fontFamily:
                                                    FontConstants.family,
                                                    fontSize: AppSize.s14,
                                                    fontWeight:
                                                    FontWeightManager.bold),
                                              ),
                                              const SizedBox(
                                                width: AppSize.s8,
                                              ),
                                              Checkbox(
                                                value: commonDataCubit
                                                    .securityLevel ==
                                                    Constants.publicSecretGuid,
                                                activeColor: Theme.of(context)
                                                    .primaryColorDark,
                                                checkColor:
                                                ColorManager.goldColor,
                                                onChanged: (bool? value) async {
                                                  if (commonDataCubit
                                                      .securityLevel !=
                                                      Constants
                                                          .publicSecretGuid) {
                                                    commonDataCubit
                                                        .changeSecurityLevel(
                                                        Constants
                                                            .publicSecretGuid);
                                                  }
                                                },
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: AppSize.s16,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: registerTextField(
                                        context: context,
                                        background: Colors.transparent,
                                        textInputType: TextInputType.text,
                                        hintText: AppStrings.letterAbout.tr(),
                                        textInputAction: TextInputAction.next,
                                        borderColor: Theme.of(context).primaryColorDark,
                                        controller: cubit.letterAboutController,
                                        validate: (value) {
                                          if (value!.isEmpty) {
                                            return AppStrings.letterAboutRequired.tr();
                                          }
                                          if (value.length < 10) {
                                            return AppStrings.lengthShorter.tr();
                                          }
                                        },
                                        onChanged: (String? value) {},
                                      ),
                                    ),
                                    const SizedBox(
                                      width: AppSize.s16,
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: registerTextField(
                                        context: context,
                                        background: Colors.transparent,
                                        textInputType: TextInputType.text,
                                        hintText: AppStrings.letterNumber.tr(),
                                        textInputAction: TextInputAction.next,
                                        borderColor: Theme.of(context).primaryColorDark,
                                        controller: cubit.letterNumberController,
                                        validate: (value) {
                                          if (value!.isEmpty) {
                                            return AppStrings.letterNumberRequired.tr();
                                          }
                                          if (value.isEmpty) {
                                            return AppStrings.lengthShorter.tr();
                                          }
                                        },
                                        onChanged: (String? value) {},
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: AppSize.s16,
                                ),
                                registerTextField(
                                  context: context,
                                  background: Colors.transparent,
                                  textInputType: TextInputType.text,
                                  hintText: AppStrings.letterContent.tr(),
                                  textInputAction: TextInputAction.next,
                                  borderColor: Theme.of(context).primaryColorDark,
                                  controller: cubit.letterContentController,
                                  maxLines: 8,
                                  contentPadding: const EdgeInsets.all(AppSize.s12),
                                  validate: (value) {
                                    if (value!.isEmpty) {
                                      return AppStrings.letterContentRequired.tr();
                                    }
                                    if (value.length < 10) {
                                      return AppStrings.lengthShorter.tr();
                                    }
                                  },
                                  onChanged: (String? value) {},
                                ),
                                const SizedBox(
                                  height: AppSize.s16,
                                ),
                                commonDataCubit.textControllersList.isNotEmpty || commonDataCubit.dateTimeList.isNotEmpty
                                    ? Container(
                                  decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.circular(AppSize.s8),
                                    border: Border.all(
                                        color: Theme.of(context).primaryColorDark,
                                        width: AppSize.s0_2),
                                  ),
                                  padding: const EdgeInsets.all(AppSize.s12),
                                  margin: const EdgeInsets.only(bottom: AppSize.s16),
                                  child: Column(
                                    children: [
                                      Align(
                                        alignment: Alignment.topCenter,
                                        child: Text(
                                          AppStrings.additionalInformation.tr(),
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColorDark,
                                              fontFamily: FontConstants.family,
                                              fontSize: AppSize.s18,
                                              fontWeight: FontWeightManager.bold),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: AppSize.s12,
                                      ),
                                      ListView.builder(
                                        physics: const ClampingScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: commonDataCubit.filteredAdditionalList.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return additionalLetterItem(
                                              context, commonDataCubit, index);
                                        },
                                      )
                                    ],
                                  ),
                                )
                                    : const SizedBox.shrink(),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    commonDataCubit.selectedActionDepartmentsList.isNotEmpty
                                        ? Expanded(
                                        child: selectedActionDepartmentsWidget(
                                            context, commonDataCubit))
                                        : const SizedBox.shrink(),
                                    SizedBox(
                                      width: (commonDataCubit.selectedKnowDepartmentsList.isNotEmpty &&
                                          commonDataCubit.selectedActionDepartmentsList.isNotEmpty)
                                          ? AppSize.s16
                                          : AppSize.s0,
                                    ),
                                    if (commonDataCubit.selectedKnowDepartmentsList.isNotEmpty)
                                      Expanded(
                                          child: selectedKnowDepartmentsWidget(context, commonDataCubit))
                                    else
                                      const SizedBox.shrink(),
                                    SizedBox(
                                      width: (commonDataCubit
                                          .selectedTagsList.isNotEmpty &&
                                          (commonDataCubit
                                              .selectedKnowDepartmentsList
                                              .isNotEmpty ||
                                              commonDataCubit
                                                  .selectedActionDepartmentsList
                                                  .isNotEmpty))
                                          ? AppSize.s16
                                          : AppSize.s0,
                                    ),
                                    commonDataCubit.selectedTagsList.isNotEmpty
                                        ? Expanded(
                                        child: tagsWidget(context, commonDataCubit))
                                        : const SizedBox.shrink(),
                                    SizedBox(
                                      width: (commonDataCubit.pickedFiles.isNotEmpty &&
                                          (commonDataCubit.selectedTagsList.isNotEmpty
                                              || commonDataCubit.selectedKnowDepartmentsList.isNotEmpty
                                              || commonDataCubit.selectedActionDepartmentsList.isNotEmpty))
                                          ? AppSize.s16
                                          : AppSize.s0,
                                    ),
                                    if (commonDataCubit.pickedFiles.isNotEmpty) Expanded(
                                      child: SizedBox(
                                        width: 350,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(AppSize.s6),
                                            color: Theme.of(context).splashColor,
                                          ),
                                          //  height: 160,
                                          padding: const EdgeInsets.symmetric(horizontal: AppSize.s12),
                                          child: Column(
                                            children: [
                                              const SizedBox(height: AppSize.s8,),
                                              Text(
                                                AppStrings.attachments.tr(),
                                                style: TextStyle(
                                                    color: Theme.of(context).primaryColorDark,
                                                    fontFamily: FontConstants.family,
                                                    fontSize: AppSize.s16,
                                                    fontWeight: FontWeightManager.bold),
                                              ),
                                              const SizedBox(height: AppSize.s8,),
                                              Align(
                                                alignment: Alignment.centerRight,
                                                child: Container(
                                                  constraints: const BoxConstraints(maxHeight: AppSize.s100),
                                                  child: ListView.builder(
                                                    shrinkWrap: true,
                                                    scrollDirection: Axis.horizontal,
                                                    itemBuilder: (context, index) {
                                                      // final uniqueKey = UniqueKey();
                                                      return Row(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        mainAxisSize: MainAxisSize.max,
                                                        children: [
                                                          Stack(
                                                            children: [
                                                              pdfPreview(context, PdfArgs(commonDataCubit.pickedFiles[index], index)),
                                                              Positioned(
                                                                right: AppSize.s6,
                                                                top: AppSize.s3,
                                                                child: Container(
                                                                    decoration: const BoxDecoration(
                                                                        shape: BoxShape.circle,
                                                                        color: Colors.red),
                                                                    padding: const EdgeInsets.all(AppSize.s4),
                                                                    child: Icon(
                                                                      Icons.close_rounded,
                                                                      color: Theme.of(context).primaryColorDark,
                                                                      size: AppSize.s10,
                                                                    )).ripple(() {
                                                                  commonDataCubit.deleteFile(commonDataCubit.pickedFiles[index]);
                                                                },
                                                                    borderRadius:
                                                                    BorderRadius.circular(AppSize.s5),
                                                                    overlayColor: MaterialStateColor.resolveWith((states) => Theme.of(context).primaryColorDark.withOpacity(AppSize.s0_2))),
                                                              ),
                                                            ],
                                                          ),
                                                          const SizedBox(width: AppSize.s8,)
                                                        ],
                                                      );
                                                    },
                                                    itemCount: commonDataCubit.pickedFiles.length,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: AppSize.s8,),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ) else const SizedBox.shrink(),
                                  ],
                                ),
                                const SizedBox(height: AppSize.s16,),


                                Align(
                                  alignment: Alignment.bottomLeft,
                                  child: defaultButton(
                                    //width: double.infinity,
                                      function: () {},
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: AppSize.s8),
                                      text: AppStrings.sendLetter.tr(),
                                      radius: AppSize.s8,
                                      background: Colors.transparent,
                                      borderColor:
                                      Theme.of(context).primaryColorDark,
                                      textStyle: TextStyle(
                                          color: Theme.of(context).primaryColorDark,
                                          fontFamily: FontConstants.family,
                                          fontSize: AppSize.s14))
                                      .ripple(() async {

                                    if (formKey.currentState!.validate()) {
                                      if (commonDataCubit.selectedKnowDepartmentsList.isEmpty &&
                                          commonDataCubit.selectedActionDepartmentsList.isEmpty) {
                                        showMToast(
                                            context, AppStrings.departmentsRequired.tr(),
                                            TextStyle(
                                                color: Theme.of(context).primaryColorDark,
                                                fontFamily: FontConstants.family,
                                                fontSize: AppSize.s16),
                                            ColorManager.goldColor.withOpacity(0.3));
                                      }else{
                                        await cubit.replyOnLetter(letterModel.letterId);
                                      }
                                    }
                                  },
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(AppSize.s8)),
                                      overlayColor: MaterialStateColor.resolveWith(
                                              (states) => Theme.of(context)
                                              .primaryColorDark
                                              .withOpacity(AppSize.s0_2))),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
            ),
    );
  }
}
