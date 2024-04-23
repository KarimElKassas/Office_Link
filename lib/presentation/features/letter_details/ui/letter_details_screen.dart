import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:foe_archiving/core/helpers/extensions.dart';
import 'package:foe_archiving/core/routing/routes.dart';
import 'package:foe_archiving/data/models/additional_information_model.dart';
import 'package:foe_archiving/data/models/letter_model.dart';
import 'package:iconly/iconly.dart';
import 'package:ionicons/ionicons.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/helpers/functions/date_time_helpers.dart';
import '../../../../core/localization/strings_manager.dart';
import '../../../../core/theming/color_manager.dart';
import '../../../../core/theming/font_manager.dart';
import '../../../../core/theming/values_manager.dart';
import '../../../../core/widgets/default_text_field.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../../../core/widgets/scale_dialog.dart';
import '../../../../core/widgets/show_toast.dart';
import '../../../shared/ui/pdf_thumbnail.dart';
import '../../../shared/widgets/custom_thumbnail.dart';
import '../../../shared/widgets/pdf_dialog.dart';
import '../bloc/letter_details_cubit.dart';
import '../bloc/letter_details_states.dart';
import '../helper/letter_details_args.dart';
import 'dart:ui' as ui;

class LetterDetailsScreen extends StatelessWidget {
  LetterDetailsScreen({super.key, required this.letterModel,required this.fromReplyScreen});
  LetterModel letterModel;
  bool fromReplyScreen;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<LetterDetailsCubit>()..getLetter(Guid(letterModel.internalDefaultLetterId.toString())),
      child: BlocConsumer<LetterDetailsCubit, LetterDetailsStates>(
        listener: (context, state) {
          if(state is LetterDetailsSuccessfulDeleteLetter){
            Navigator.pop(context);
            Navigator.pop(context);
          }
          if(state is LetterDetailsErrorDeleteLetter){
            Navigator.pop(context);
            showMToast(context, AppStrings.cannotDeleteLetterHasReply.tr(), TextStyle(color: Theme.of(context).primaryColorDark,fontFamily: FontConstants.family,fontSize: AppSize.s16), ColorManager.goldColor.withOpacity(0.3));
          }

        },
        builder: (context, state) {
          var cubit = LetterDetailsCubit.get(context);
          print("IS Not EMPTY : ${cubit.additionalInfoList.isNotEmpty}");

          if (cubit.letterModel == null) {
            return Scaffold(
              appBar: fromReplyScreen
                  ? AppBar(toolbarHeight: 0)
                  : AppBar(
                automaticallyImplyLeading: true,
                centerTitle: true,
                iconTheme: IconThemeData(color: Theme.of(context).primaryColorDark),
                title: RichText(
                  text: TextSpan(children: [
                    TextSpan(
                        text: AppStrings.letterDetails.tr(),
                        style: TextStyle(
                            color: Theme.of(context).primaryColorDark,
                            fontSize: AppSize.s18,
                            fontFamily: FontConstants.family,
                            fontWeight: FontWeightManager.regular)),
                    TextSpan(
                        text: cubit.letterModel?.letterNumber,
                        style: TextStyle(
                            color: ColorManager.goldColor,
                            fontSize: AppSize.s18,
                            fontFamily: FontConstants.family,
                            fontWeight: FontWeightManager.bold)),
                  ]),
                ),
              ),
              backgroundColor: Theme.of(context).primaryColorLight,
              body: Center(
                child: loadingIndicator(),
              ),
            );
          } else {
            return Scaffold(
              appBar: fromReplyScreen
                  ? AppBar(toolbarHeight: 0)
                  : AppBar(
                automaticallyImplyLeading: true,
                iconTheme: IconThemeData(
                    color: Theme.of(context).primaryColorDark),
                title: Row(
                  children: [
                    RichText(
                      text: TextSpan(children: [
                        TextSpan(
                            text: AppStrings.letterDetails.tr(),
                            style: TextStyle(
                                color: Theme.of(context).primaryColorDark,
                                fontSize: AppSize.s18,
                                fontFamily: FontConstants.family,
                                fontWeight: FontWeightManager.regular)),
                        TextSpan(
                            text: cubit.letterModel?.letterNumber,
                            style: TextStyle(
                                color: ColorManager.goldColor,
                                fontSize: AppSize.s18,
                                fontFamily: FontConstants.family,
                                fontWeight: FontWeightManager.bold)),
                      ]),
                    ),
                    const Spacer(),
/*                    if(cubit.isLetterMine(letterModel))
                      PopupMenuButton<int>(
                        color: Theme.of(context).splashColor,
                        icon: Icon(Icons.more_vert_rounded, color: Theme.of(context).primaryColorDark,),
                        onSelected: (item){
                          if(item == 0){
                            Navigator.pushNamed(
                                context, Routes.updateLetterRoute,
                                arguments: UpdateLetterArgs(cubit.letterModel!, cubit.pickedFiles, cubit.selectedActionDepartmentsList, cubit.selectedKnowDepartmentsList)).then((value){
                              cubit.getLetter(letterModel.letterId);
                            });
                          }else{
                            scaleDialog(context, true, alterDeleteDialog(context, cubit));
                          }
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem<int>(value: 0, child: Text(AppStrings.updateLetter.tr(), style: TextStyle(
                              color: Theme.of(context).primaryColorDark,
                              fontFamily: FontConstants.family,
                              fontSize: AppSize.s14,
                              fontWeight: FontWeightManager.bold))),
                          PopupMenuItem<int>(value: 1, child: Text(AppStrings.deleteLetter.tr(), style: TextStyle(
                              color: Theme.of(context).primaryColorDark,
                              fontFamily: FontConstants.family,
                              fontSize: AppSize.s14,
                              fontWeight: FontWeightManager.bold))),
                        ],
                      )*/
                  ],
                ),
              ),
              backgroundColor: Theme.of(context).primaryColorLight,
              floatingActionButton:
              fromReplyScreen || !cubit.canReply(cubit.letterModel!)
                  ? const SizedBox.shrink()
                  : MouseRegion(
                cursor: MaterialStateMouseCursor.clickable,
                child: Container(
                  padding: const EdgeInsets.all(AppSize.s8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppSize.s8),
                    color: Colors.transparent,
                    border: Border.all(
                        color: Theme.of(context).primaryColorDark,
                        width: AppSize.s1),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(
                        Ionicons.caret_forward,
                        color: Theme.of(context).primaryColorDark,
                      ),
                      const SizedBox(width: AppSize.s8),
                      Text(
                        AppStrings.replyOnLetter.tr(),
                        style: TextStyle(
                            color: Theme.of(context).primaryColorDark,
                            fontFamily: FontConstants.family,
                            fontSize: AppSize.s18,
                            fontWeight: FontWeightManager.bold),
                      ),
                    ],
                  ),
                ),
              ).ripple(() {
                if (cubit.canReply(cubit.letterModel!)) {
                  Navigator.pushNamed(
                      context, Routes.letterReplyRoute,
                      arguments: cubit.letterModel!);
                } else {}
              },
                  borderRadius: BorderRadius.circular(AppSize.s8),
                  overlayColor: MaterialStateColor.resolveWith(
                          (states) => Theme.of(context)
                          .primaryColorDark
                          .withOpacity(AppSize.s0_2))),
              body: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Theme.of(context).splashColor,
                                    borderRadius: BorderRadius.circular(AppSize.s8)),
                                margin: const EdgeInsets.symmetric(
                                    vertical: AppSize.s12, horizontal: AppSize.s16),
                                padding: const EdgeInsets.symmetric(
                                    vertical: AppSize.s12, horizontal: AppSize.s16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    Text(
                                      cubit.isLetterMine(letterModel) ? AppStrings.receiverDirection.tr() : AppStrings.letterDirection.tr(),
                                      style: TextStyle(
                                          color: ColorManager.goldColor,
                                          fontSize: AppSize.s18,
                                          fontFamily: FontConstants.family,
                                          fontWeight: FontWeightManager.bold),
                                    ),
                                    const SizedBox(
                                      height: AppSize.s12,
                                    ),
                                    cubit.isLetterMine(letterModel) ?
                                    FutureBuilder<String>(
                                      future: cubit.receiverDepartmentName(),
                                      builder: (context,snapshot){
                                         if (snapshot.hasError) {
                                          // If an error occurred
                                           print("ERROR : ${snapshot.error}");
                                          return Text(
                                            AppStrings.notFound.tr(),
                                            style: TextStyle(
                                                color: Theme.of(context).primaryColorDark,
                                                fontSize: AppSize.s16,
                                                fontFamily: FontConstants.family,
                                                fontWeight: FontWeightManager.regular),
                                          );
                                        } else {
                                          // If the future has resolved successfully
                                          return Text(
                                            snapshot.data??"-",
                                            style: TextStyle(
                                                color: Theme.of(context).primaryColorDark,
                                                fontSize: AppSize.s16,
                                                fontFamily: FontConstants.family,
                                                fontWeight: FontWeightManager.regular),
                                          ); // Display the text
                                        }
                                      },
                                    ) : Text(
                                      cubit.letterModel!.departmentName??"-",
                                      style: TextStyle(
                                          color: Theme.of(context).primaryColorDark,
                                          fontSize: AppSize.s16,
                                          fontFamily: FontConstants.family,
                                          fontWeight: FontWeightManager.regular),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: AppSize.s16,
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Theme.of(context).splashColor,
                                    borderRadius: BorderRadius.circular(AppSize.s8)),
                                margin: const EdgeInsets.symmetric(
                                    vertical: AppSize.s12, horizontal: AppSize.s16),
                                padding: const EdgeInsets.symmetric(
                                    vertical: AppSize.s12, horizontal: AppSize.s16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    Text(
                                      AppStrings.letterDate.tr(),
                                      style: TextStyle(
                                          color: ColorManager.goldColor,
                                          fontSize: AppSize.s18,
                                          fontFamily: FontConstants.family,
                                          fontWeight: FontWeightManager.bold),
                                    ),
                                    const SizedBox(
                                      height: AppSize.s12,
                                    ),
                                    Text(
                                      formatDate(cubit.letterModel!.letterDate),
                                      style: TextStyle(
                                          color: Theme.of(context).primaryColorDark,
                                          fontSize: AppSize.s16,
                                          fontFamily: FontConstants.family,
                                          fontWeight: FontWeightManager.regular),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: AppSize.s16,
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Theme.of(context).splashColor,
                                    borderRadius: BorderRadius.circular(AppSize.s8)),
                                margin: const EdgeInsets.symmetric(
                                    vertical: AppSize.s12, horizontal: AppSize.s16),
                                padding: const EdgeInsets.symmetric(
                                    vertical: AppSize.s12, horizontal: AppSize.s16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    Text(
                                      AppStrings.attachments.tr(),
                                      style: TextStyle(
                                          color: ColorManager.goldColor,
                                          fontSize: AppSize.s18,
                                          fontFamily: FontConstants.family,
                                          fontWeight: FontWeightManager.bold),
                                    ),
                                    const SizedBox(
                                      height: AppSize.s12,
                                    ),
                                    Text(
                                      cubit.letterAttachmentsToString(cubit.letterModel!),
                                      style: TextStyle(
                                          color: Theme.of(context).primaryColorDark,
                                          fontSize: AppSize.s16,
                                          fontFamily: FontConstants.family,
                                          fontWeight: FontWeightManager.regular),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Theme.of(context).splashColor,
                                    borderRadius: BorderRadius.circular(AppSize.s8)),
                                margin: const EdgeInsets.symmetric(
                                    vertical: AppSize.s12, horizontal: AppSize.s16),
                                padding: const EdgeInsets.symmetric(
                                    vertical: AppSize.s12, horizontal: AppSize.s16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    Text(
                                      AppStrings.letterAbout.tr(),
                                      style: TextStyle(
                                          color: ColorManager.goldColor,
                                          fontSize: AppSize.s18,
                                          fontFamily: FontConstants.family,
                                          fontWeight: FontWeightManager.bold),
                                    ),
                                    const SizedBox(
                                      height: AppSize.s12,
                                    ),
                                    Text(
                                      cubit.letterModel!.letterAbout,
                                      style: TextStyle(
                                          color: Theme.of(context).primaryColorDark,
                                          fontSize: AppSize.s16,
                                          fontFamily: FontConstants.family,
                                          fontWeight: FontWeightManager.regular),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: AppSize.s16,
                            ),
                            Expanded(
                              flex: 2,
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Theme.of(context).splashColor,
                                    borderRadius: BorderRadius.circular(AppSize.s8)),
                                margin: const EdgeInsets.symmetric(
                                    vertical: AppSize.s12, horizontal: AppSize.s16),
                                padding: const EdgeInsets.symmetric(
                                    vertical: AppSize.s12, horizontal: AppSize.s16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    Text(
                                      AppStrings.letterContent.tr(),
                                      style: TextStyle(
                                          color: ColorManager.goldColor,
                                          fontSize: AppSize.s18,
                                          fontFamily: FontConstants.family,
                                          fontWeight: FontWeightManager.bold),
                                    ),
                                    const SizedBox(
                                      height: AppSize.s12,
                                    ),
                                    Text(
                                      cubit.letterModel!.letterContent,
                                      style: TextStyle(
                                          color: Theme.of(context).primaryColorDark,
                                          fontSize: AppSize.s16,
                                          fontFamily: FontConstants.family,
                                          fontWeight: FontWeightManager.regular),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: AppSize.s12),
                        cubit.additionalInfoList.isNotEmpty ?
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(AppSize.s8),
                            border: Border.all(
                                color: Theme.of(context).primaryColorDark,
                                width: AppSize.s0_2),
                          ),
                          padding: const EdgeInsets.all(AppSize.s12),
                          margin: const EdgeInsets.only(bottom: AppSize.s16,left: AppSize.s16,right: AppSize.s16),
                          constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height / 3),
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
                              Expanded(
                                child: ListView.builder(
                                  physics: const ClampingScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: cubit.additionalInfoList.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return additionalLetterItem(context, cubit.additionalInfoList[index]!);
                                  },
                                ),
                              )
                            ],
                          ),
                        ) : const SizedBox.shrink(),
                        const SizedBox(
                          height: AppSize.s12,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              width: AppSize.s16,
                            ),
                            cubit.selectedActionDepartmentsList.isNotEmpty
                                ? selectedActionDepartmentsWidget(context, cubit)
                                : const SizedBox.shrink(),
                            SizedBox(
                              width: cubit.selectedKnowDepartmentsList.isNotEmpty
                                  ? AppSize.s16
                                  : AppSize.s0,
                            ),
                            cubit.selectedKnowDepartmentsList.isNotEmpty
                                ? selectedKnowDepartmentsWidget(context, cubit)
                                : const SizedBox.shrink(),
                            SizedBox(
                              width:
                              cubit.filesList.isNotEmpty
                                  ? AppSize.s16
                                  : AppSize.s0,
                            ),
                            cubit.filesList.isNotEmpty
                                ? SizedBox(
                              width: 350,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.circular(AppSize.s6),
                                  color: Theme.of(context).splashColor,
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: AppSize.s12),
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: AppSize.s8,
                                    ),
                                    Text(
                                      AppStrings.attachments.tr(),
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .primaryColorDark,
                                          fontFamily: FontConstants.family,
                                          fontSize: AppSize.s16,
                                          fontWeight: FontWeightManager.bold),
                                    ),
                                    const SizedBox(
                                      height: AppSize.s8,
                                    ),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Container(
                                        constraints: const BoxConstraints(maxHeight: AppSize.s50),
                                        child: ListView.builder(
                                          shrinkWrap: true,
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder: (context, index) {
                                            return pdfPreview(context, PdfArgs(PlatformFile(path: cubit.filesList[index].filePath,name: cubit.filesList[index].fileName,
                                                size: int.parse(cubit.filesList[index].fileSize.toString())), index));
                                          },
                                          itemCount: cubit.filesList.length,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: AppSize.s8,
                                    ),
                                  ],
                                ),
                              ),
                            )
                                : const SizedBox.shrink(),
                          ],
                        ),
                        if (cubit.repliesList.isNotEmpty) const Spacer(),
                        cubit.repliesList.isNotEmpty
                            ? Align(
                          alignment: Alignment.bottomRight,
                          child: Container(
                            decoration: BoxDecoration(
                                color: Theme.of(context).splashColor,
                                borderRadius:
                                BorderRadius.circular(AppSize.s8)),
                            margin: const EdgeInsets.symmetric(
                                vertical: AppSize.s12, horizontal: AppSize.s16),
                            padding: const EdgeInsets.symmetric(
                                vertical: AppSize.s12, horizontal: AppSize.s16),
                            child: Column(
                              children: [
                                Text(
                                  AppStrings.letterReplies.tr(),
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColorDark,
                                      fontSize: AppSize.s18,
                                      fontFamily: FontConstants.family,
                                      fontWeight: FontWeightManager.bold),
                                ),
                                const SizedBox(
                                  height: AppSize.s12,
                                ),
                                MouseRegion(
                                  cursor: MaterialStateMouseCursor.clickable,
                                  onEnter: (_) => cubit
                                      .changeLetterNumberColor(Colors.blue),
                                  onExit: (_) => cubit.changeLetterNumberColor(
                                      ColorManager.goldColor),
                                  child: GestureDetector(
                                    onTap: () => scaleDialog(context, true,
                                        alterLetterDialog(context, cubit.repliesList)),
                                    child: Text(
                                      cubit.repliesList[0]
                                          .letterNumber
                                          .toString(),
                                      style: TextStyle(
                                          color: cubit.letterNumberColor,
                                          fontSize: AppSize.s18,
                                          fontFamily: FontConstants.family,
                                          fontWeight: FontWeightManager.bold,
                                          decoration: TextDecoration.underline),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                            : const SizedBox.shrink()
                      ],
                    ),
                  ),
                  cubit.isLetterMine(cubit.letterModel!) ?
                  Expanded(
                    flex: 1,
                    child: Container(
                      height: double.infinity,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColorLight,
                        border: Border(
                          right: BorderSide(
                            color: ColorManager.goldColor,
                            width: 1.0,
                          ),
                        ),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            seenWidget(context, cubit),
                            const SizedBox(height: AppSize.s12,),
                            unSeenWidget(context, cubit)
                          ],
                        ),
                      ),
                    ),
                  ) : const SizedBox.shrink()
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

Widget seenWidget(BuildContext context, LetterDetailsCubit cubit){
  return Container(
    decoration: BoxDecoration(
        color: Theme.of(context).splashColor,
        borderRadius: BorderRadius.circular(AppSize.s8)),
    margin: const EdgeInsets.symmetric(
        vertical: AppSize.s12, horizontal: AppSize.s12),
    padding: const EdgeInsets.symmetric(
        vertical: AppSize.s12, horizontal: AppSize.s8),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(IconlyBroken.shield_done, color: ColorManager.goldColor,),
              const SizedBox(width: AppSize.s8,),
              Text(
                AppStrings.seenDepartments.tr(),
                style: TextStyle(
                    color: ColorManager.goldColor,
                    fontSize: AppSize.s18,
                    fontFamily: FontConstants.family,
                    fontWeight: FontWeightManager.bold),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: AppSize.s12,
        ),
        cubit.seenDepartmentsList.isNotEmpty ?
        Container(
          padding: const EdgeInsets.symmetric(horizontal: AppSize.s8,vertical: AppSize.s6 ),
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColorLight,
              borderRadius: BorderRadius.circular(AppSize.s4)),
          child: ListView.builder(
            physics: const ClampingScrollPhysics(),
            shrinkWrap: true,
            itemCount: cubit.seenDepartmentsList.length,
            itemBuilder: (BuildContext context, int index) {
              return seenItem(context, cubit, index);
            },
          ),
        ) : Center(
          child: Text(
            AppStrings.notFound.tr(),
            style: TextStyle(
                color: ColorManager.goldColor,
                fontSize: AppSize.s16,
                fontFamily: FontConstants.family,
                fontWeight: FontWeightManager.bold),
          ),
        )
      ],
    ),
  );
}
Widget unSeenWidget(BuildContext context, LetterDetailsCubit cubit){
  return Container(
    decoration: BoxDecoration(
        color: Theme.of(context).splashColor,
        borderRadius: BorderRadius.circular(AppSize.s8)),
    margin: const EdgeInsets.symmetric(
        vertical: AppSize.s12, horizontal: AppSize.s12),
    padding: const EdgeInsets.symmetric(
        vertical: AppSize.s12, horizontal: AppSize.s8),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(IconlyBroken.paper_fail, color: ColorManager.goldColor,),
              const SizedBox(width: AppSize.s8,),
              Text(
                AppStrings.unSeenDepartments.tr(),
                style: TextStyle(
                    color: ColorManager.goldColor,
                    fontSize: AppSize.s18,
                    fontFamily: FontConstants.family,
                    fontWeight: FontWeightManager.bold),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: AppSize.s12,
        ),
        cubit.unSeenDepartmentsList.isNotEmpty ?
        Container(
          padding: const EdgeInsets.symmetric(horizontal: AppSize.s8,vertical: AppSize.s6 ),
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColorLight,
              borderRadius: BorderRadius.circular(AppSize.s4)),
          child: ListView.builder(
            physics: const ClampingScrollPhysics(),
            shrinkWrap: true,
            itemCount: cubit.unSeenDepartmentsList.length,
            itemBuilder: (BuildContext context, int index) {
              return unSeenItem(context, cubit, index);
            },
          ),
        ) : Center(
          child: Text(
            AppStrings.notFound.tr(),
            style: TextStyle(
                color: ColorManager.goldColor,
                fontSize: AppSize.s16,
                fontFamily: FontConstants.family,
                fontWeight: FontWeightManager.bold),
          ),
        )
      ],
    ),
  );
}
Widget seenItem(BuildContext context, LetterDetailsCubit cubit, int index){
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: AppSize.s8,vertical: AppSize.s6),
    margin: const EdgeInsets.symmetric(vertical: AppSize.s6),
    decoration: BoxDecoration(
        color: Theme.of(context).splashColor,
        borderRadius: BorderRadius.circular(AppSize.s8)),
    child: Column(
      children: [
        Row(
          children: [
            Text(
              "${AppStrings.department.tr()} : ",
              style: TextStyle(
                  color: Theme.of(context).primaryColorDark,
                  fontSize: AppSize.s16,
                  fontWeight: FontWeightManager.bold,
                  fontFamily: FontConstants.family),
            ),
            Text(
              cubit.seenDepartmentsList[index]['departmentName'],
              style: TextStyle(
                  color: Theme.of(context).primaryColorDark,
                  fontSize: AppSize.s16,
                  fontWeight: FontWeightManager.bold,
                  fontFamily: FontConstants.family),
            ),
          ],
        ),
        const SizedBox(height: AppSize.s12,),
        Row(
          children: [
            Text(
              "${AppStrings.seenDate.tr()} : ",
              style: TextStyle(
                  color: Theme.of(context).primaryColorDark,
                  fontSize: AppSize.s16,
                  fontWeight: FontWeightManager.bold,
                  fontFamily: FontConstants.family),
            ),
            Text(
              formatDateTime(cubit.seenDepartmentsList[index]['seenAt'].toString()),
              style: TextStyle(
                  color: Theme.of(context).primaryColorDark,
                  fontSize: AppSize.s16,
                  fontWeight: FontWeightManager.bold,
                  fontFamily: FontConstants.family),
            ),
          ],
        ),
      ],
    ),
  );
}
Widget unSeenItem(BuildContext context, LetterDetailsCubit cubit, int index){
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: AppSize.s8,vertical: AppSize.s6),
    margin: const EdgeInsets.symmetric(vertical: AppSize.s6),
    decoration: BoxDecoration(
        color: Theme.of(context).splashColor,
        borderRadius: BorderRadius.circular(AppSize.s8)),
    child: Column(
      children: [
        Row(
          children: [
            Text(
              "${AppStrings.department.tr()} : ",
              style: TextStyle(
                  color: Theme.of(context).primaryColorDark,
                  fontSize: AppSize.s16,
                  fontWeight: FontWeightManager.bold,
                  fontFamily: FontConstants.family),
            ),
            Text(
              cubit.unSeenDepartmentsList[index]??"",
              style: TextStyle(
                  color: Theme.of(context).primaryColorDark,
                  fontSize: AppSize.s16,
                  fontWeight: FontWeightManager.bold,
                  fontFamily: FontConstants.family),
            ),
          ],
        ),
        const SizedBox(height: AppSize.s12,),
        Row(
          children: [
            Text(
              "${AppStrings.seenDate.tr()} : ",
              style: TextStyle(
                  color: Theme.of(context).primaryColorDark,
                  fontSize: AppSize.s16,
                  fontWeight: FontWeightManager.bold,
                  fontFamily: FontConstants.family),
            ),
            Text(
              AppStrings.notFound.tr(),
              style: TextStyle(
                  color: Theme.of(context).primaryColorDark,
                  fontSize: AppSize.s16,
                  fontWeight: FontWeightManager.bold,
                  fontFamily: FontConstants.family),
            ),
          ],
        ),
      ],
    ),
  );
}
Widget alterDeleteDialog(BuildContext context, LetterDetailsCubit cubit) {
  bool isClosing = false;

  return Directionality(
    textDirection: ui.TextDirection.rtl,
    child: AlertDialog(
      // <-- SEE HERE
        title: Text(
          AppStrings.warning.tr(),
          style: TextStyle(
              color: Theme
                  .of(context)
                  .primaryColorDark,
              fontSize: AppSize.s16,
              fontWeight: FontWeightManager.bold,
              fontFamily: FontConstants.family),
        ),
        backgroundColor: Theme
            .of(context)
            .splashColor,
        titlePadding: const EdgeInsets.only(
            top: AppSize.s12, left: AppSize.s12, right: AppSize.s12),
        contentPadding: const EdgeInsets.all(AppSize.s12),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(
                AppStrings.areYouSureDeleteThisLetter.tr(),
                style: TextStyle(
                    color: Theme
                        .of(context)
                        .primaryColorDark,
                    fontSize: AppSize.s14,
                    fontWeight: FontWeightManager.bold,
                    fontFamily: FontConstants.family),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () async {
              cubit.deleteLetter();
            },
            style: ButtonStyle(
                overlayColor: MaterialStateColor.resolveWith(
                        (states) => ColorManager.goldColor.withOpacity(0.4))),
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
            onPressed: () {
              if (!isClosing) {
                isClosing = true;
                Navigator.of(context).pop();
              }
            },
            style: ButtonStyle(
                overlayColor: MaterialStateColor.resolveWith(
                        (states) => ColorManager.goldColor.withOpacity(0.4))),
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
Widget selectedKnowDepartmentsWidget(BuildContext context, LetterDetailsCubit cubit) {
  return Container(
    width: 350,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(AppSize.s6),
      color: Theme.of(context).splashColor,
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(
          height: AppSize.s8,
        ),
        Text(
          AppStrings.requiredKnowFromDepartments.tr(),
          style: TextStyle(
              color: Theme.of(context).primaryColorDark,
              fontFamily: FontConstants.family,
              fontSize: AppSize.s16,
              fontWeight: FontWeightManager.bold),
        ),
        const SizedBox(
          height: AppSize.s4,
        ),
        Flexible(
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppSize.s6),
                  color: ColorManager.goldColor.withOpacity(0.2),
                ),
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSize.s8, vertical: AppSize.s8),
                margin: const EdgeInsets.all(AppSize.s6),
                child: Text(
                  '${cubit.selectedKnowDepartmentsList[index]!.sectorName} - ${cubit.selectedKnowDepartmentsList[index]!.departmentName}',
                  style: TextStyle(
                      color: Theme.of(context).primaryColorDark,
                      fontFamily: FontConstants.family,
                      fontSize: AppSize.s14,
                      fontWeight: FontWeightManager.bold),
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
Widget selectedActionDepartmentsWidget(BuildContext context, LetterDetailsCubit cubit) {
  return Container(
    width: 350,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(AppSize.s6),
      color: Theme.of(context).splashColor,
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(
          height: AppSize.s8,
        ),
        Text(
          AppStrings.requiredActionFromDepartments.tr(),
          style: TextStyle(
              color: Theme.of(context).primaryColorDark,
              fontFamily: FontConstants.family,
              fontSize: AppSize.s16,
              fontWeight: FontWeightManager.bold),
        ),
        const SizedBox(height: AppSize.s4),
        ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSize.s6),
                color: ColorManager.goldColor.withOpacity(0.2),
              ),
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSize.s8, vertical: AppSize.s8),
              margin: const EdgeInsets.all(AppSize.s6),
              child: Text(
                '${cubit.selectedActionDepartmentsList[index]!.sectorName} - ${cubit.selectedActionDepartmentsList[index]!.departmentName}',
                style: TextStyle(
                    color: Theme.of(context).primaryColorDark,
                    fontFamily: FontConstants.family,
                    fontSize: AppSize.s14,
                    fontWeight: FontWeightManager.bold),
              ),
            );
          },
          itemCount: cubit.selectedActionDepartmentsList.length,
        ),
      ],
    ),
  );
}
Widget alterLetterDialog(BuildContext context, List<LetterModel> repliesList) {
  bool _isClosing = false;
  return Directionality(
    textDirection: ui.TextDirection.rtl,
    child: AlertDialog(
      // <-- SEE HERE
        title: Text(
          AppStrings.replyOnLetter.tr(),
          style: TextStyle(
              color: Theme.of(context).primaryColorDark,
              fontSize: AppSize.s16,
              fontWeight: FontWeightManager.bold,
              fontFamily: FontConstants.family),
        ),
        backgroundColor: Theme.of(context).primaryColorLight,
        titlePadding: const EdgeInsets.only(
            top: AppSize.s12, left: AppSize.s12, right: AppSize.s12),
        contentPadding: const EdgeInsets.all(AppSize.s12),
        content: SizedBox(
            height: AppSize.s75Height,
            width: MediaQuery.sizeOf(context).width * 0.80,
            child: LetterDetailsScreen(
              letterModel: repliesList[0],
              fromReplyScreen: true,
            )),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              if (!_isClosing) {
                _isClosing = true;
                Navigator.of(context).pop();
              }
            },
            style: ButtonStyle(
                overlayColor: MaterialStateColor.resolveWith(
                        (states) => ColorManager.goldColor.withOpacity(0.4))),
            child: Text(
              AppStrings.exit.tr(),
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
}
Widget additionalLetterItem(BuildContext context, AdditionalInformationModel informationModel) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: AppSize.s8),
    child: Row(
      children: [
        Expanded(
          child: Text(
            informationModel.additionInfoDescription??"-",
            style: TextStyle(
                color: Theme.of(context).primaryColorDark,
                fontFamily: FontConstants.family,
                fontSize: AppSize.s16,
                fontWeight: FontWeightManager.regular),
            maxLines: AppSize.s1.toInt(),
          ),
        ),
        const SizedBox(
          width: AppSize.s8,
        ),
        additionalLetterValueWidget(context, informationModel),
      ],
    ),
  );
}
Widget additionalLetterValueWidget(BuildContext context, AdditionalInformationModel informationModel){
  if(informationModel.valueType == 2){
    return Expanded(
      child: registerTextField(
        context: context,
        background: Colors.transparent,
        textInputType: TextInputType.text,
        hintText: informationModel.additionInfoDescription??"-",
        textInputAction: TextInputAction.done,
        readOnly: true,
        borderColor: Theme.of(context).primaryColorDark,
        maxLines: 2,
        validate: (value) {
          if(value!.isEmpty){
            return AppStrings.letterNumber.tr();
          }
          if(value.length < 10){
            return AppStrings.lengthShorter.tr();
          }
        },
        onChanged: (String? value) {},
      ),
    );
  }else{
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSize.s6),
            border: Border.all(color: Theme.of(context).primaryColorDark.withOpacity(0.3)),
            color: Colors.transparent
        ),
        padding: const EdgeInsets.symmetric(
            horizontal: AppSize.s8,
            vertical: AppSize.s8),
        child: Text(
          formatDate(informationModel.infoDate.toString()),
          style: TextStyle(color: Theme.of(context).primaryColorDark,
              fontSize: AppSize.s16,
              fontFamily: FontConstants.family),
        ));
  }
}

