import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:foe_archiving/core/helpers/functions/save_pdf_function.dart';
import 'package:foe_archiving/core/widgets/show_toast.dart';
import 'package:foe_archiving/presentation/shared/bloc/common_data_cubit.dart';
import 'package:printing/printing.dart';

import '../../../core/di/service_locator.dart';
import '../../../core/localization/strings_manager.dart';
import '../../../core/theming/color_manager.dart';
import '../../../core/theming/font_manager.dart';
import '../../../core/theming/values_manager.dart';
import 'dart:ui' as ui;
import '../../../core/widgets/pdf_viewer.dart';

Widget alterPdfDialog(BuildContext context, PlatformFile file) {
  bool _isClosing = false;
  return Directionality(
    textDirection: ui.TextDirection.rtl,
    child: AlertDialog(
        title: Text(
          file.name,
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
            width: AppSize.sFullWidth,
            /*child: PdfViewer(
              file: file,
            )*/),
        actions: <Widget>[
          TextButton(
            onPressed: () async {
              try {
                bool result = await saveFileToStorage(File(file.path!));
                if(result){
                  showMToast(context, 'تم التحميل بنجاح ', TextStyle(color: Theme.of(context).primaryColorDark,fontFamily: FontConstants.family),ColorManager.goldColor.withOpacity(0.3));
                }
              } on Exception catch (e) {
                debugPrint(e.toString());
              }
            },
            style: ButtonStyle(overlayColor: MaterialStateColor.resolveWith((states) => ColorManager.goldColor.withOpacity(0.4))),
            child: Text(
              AppStrings.downloadPdf.tr(),
              style: TextStyle(
                  fontSize: AppSize.s14,
                  fontFamily: FontConstants.family,
                  fontWeight: FontWeightManager.heavy,
                  color: Theme.of(context).primaryColorDark),
              maxLines: AppSize.s1.toInt(),
            ),
          ),
          TextButton(
            onPressed: () async {
              await sl<CommonDataCubit>().printPdf(File(file.path!));
            },
            style: ButtonStyle(overlayColor: MaterialStateColor.resolveWith((states) => ColorManager.goldColor.withOpacity(0.4))),
            child: Text(
              AppStrings.print.tr(),
              style: TextStyle(
                  fontSize: AppSize.s14,
                  fontFamily: FontConstants.family,
                  fontWeight: FontWeightManager.heavy,
                  color: Theme.of(context).primaryColorDark),
              maxLines: AppSize.s1.toInt(),
            ),
          ),
          TextButton(
            onPressed: () {
              if (!_isClosing) {
                _isClosing = true;
                Navigator.of(context).pop();
              }
            },
            style: ButtonStyle(overlayColor: MaterialStateColor.resolveWith((states) => ColorManager.goldColor.withOpacity(0.4))),
            child: Text(
              AppStrings.exit.tr(),
              style: TextStyle(
                  fontSize: AppSize.s14,
                  fontFamily: FontConstants.family,
                  fontWeight: FontWeightManager.heavy,
                  color: Theme.of(context).primaryColorDark),
              maxLines: AppSize.s1.toInt(),
            ),
          )
        ],
        buttonPadding: const EdgeInsets.all(AppSize.s10)),
  );
}
