import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:foe_archiving/core/routing/routes.dart';
import 'package:foe_archiving/data/models/letter_model.dart';
import 'package:foe_archiving/presentation/features/files_and_contracts/file_and_contract_details/bloc/file_and_contract_details_cubit.dart';
import 'package:foe_archiving/presentation/features/files_and_contracts/file_and_contract_details/bloc/file_and_contract_details_states.dart';

import '../../../../../core/di/service_locator.dart';
import '../../../../../core/helpers/functions/date_time_helpers.dart';
import '../../../../../core/localization/strings_manager.dart';
import '../../../../../core/theming/color_manager.dart';
import '../../../../../core/theming/font_manager.dart';
import '../../../../../core/theming/values_manager.dart';
import '../../../../../core/widgets/loading_indicator.dart';
import '../../../../../core/widgets/scale_dialog.dart';
import '../../../../shared/ui/pdf_thumbnail.dart';
import '../../../letter_details/helper/letter_details_args.dart';
import 'dart:ui' as ui;

import '../../all_files_and_contracts/bloc/all_files_and_contracts_cubit.dart';

class FileAndContractDetailsScreen extends StatelessWidget {
  FileAndContractDetailsScreen({super.key, required this.letterModel, required this.allFilesAndContractsCubit});
  LetterModel letterModel;
  final AllFilesAndContractsCubit allFilesAndContractsCubit;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<FileAndContractDetailsCubit>()..getContract(Guid(letterModel.letterId.toString())),
      child: BlocConsumer<FileAndContractDetailsCubit, FileAndContractDetailsStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = FileAndContractDetailsCubit.get(context);
          if (cubit.letterModel == null) {
            return Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: true,
                centerTitle: true,
                iconTheme: IconThemeData(color: Theme.of(context).primaryColorDark),
                title: RichText(
                  text: TextSpan(children: [
                    TextSpan(
                        text: AppStrings.contractDetails.tr(),
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
              appBar: AppBar(
                automaticallyImplyLeading: true,
                iconTheme: IconThemeData(
                    color: Theme.of(context).primaryColorDark),
                title: Row(
                  children: [
                    RichText(
                      text: TextSpan(children: [
                        TextSpan(
                            text: AppStrings.filesAndContractsDetails.tr(),
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
                    PopupMenuButton<int>(
                      color: Theme.of(context).splashColor,
                      icon: Icon(Icons.more_vert_rounded, color: Theme.of(context).primaryColorDark,),
                      onSelected: (item){
                        if(item == 0){
                          Navigator.pushNamed(
                              context, Routes.updateLetterRoute,
                              arguments: UpdateLetterArgs(cubit.letterModel!, cubit.pickedFiles, [], [])).then((value){
                            cubit.getContract(letterModel.letterId);
                          });
                        }else{
                          scaleDialog(context, true, alterDeleteDialog(context, cubit,allFilesAndContractsCubit));
                        }
                      },
                      itemBuilder: (context) => [
                        // PopupMenuItem<int>(value: 0, child: Text(AppStrings.updateContract.tr(), style: TextStyle(
                        //     color: Theme.of(context).primaryColorDark,
                        //     fontFamily: FontConstants.family,
                        //     fontSize: AppSize.s14,
                        //     fontWeight: FontWeightManager.bold))),
                        PopupMenuItem<int>(value: 1, child: Text(AppStrings.deleteContract.tr(), style: TextStyle(
                            color: Theme.of(context).primaryColorDark,
                            fontFamily: FontConstants.family,
                            fontSize: AppSize.s14,
                            fontWeight: FontWeightManager.bold))),
                      ],
                    )
                  ],
                ),
              ),
              backgroundColor: Theme.of(context).primaryColorLight,
              body: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            Expanded(
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
                                      AppStrings.contractDate.tr(),
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
                                      cubit.letterAttachmentsToString(),
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
                                      AppStrings.filesAndContractsContent.tr(),
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
                            //  height: 160,
                            padding: const EdgeInsets.symmetric(horizontal: AppSize.s12),
                            margin: const EdgeInsets.symmetric(horizontal: AppSize.s16),
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
                                const SizedBox(height: AppSize.s8,),
                              ],
                            ),
                          ),
                        ) : const SizedBox.shrink(),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

Widget alterDeleteDialog(BuildContext context, FileAndContractDetailsCubit cubit,AllFilesAndContractsCubit allFilesAndContractsCubit) {
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
                AppStrings.areYouSureDeleteThisContract.tr(),
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
              cubit.deleteContract(allFilesAndContractsCubit).then((value){
                Navigator.pop(context);

                Navigator.pop(context);


              });
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