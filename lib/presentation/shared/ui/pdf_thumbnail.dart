import 'package:flutter/material.dart';
import 'package:foe_archiving/core/helpers/extensions.dart';
import 'package:foe_archiving/core/helpers/notification_service.dart';
import 'package:foe_archiving/core/widgets/scale_dialog.dart';
import 'package:foe_archiving/presentation/features/letter_details/helper/letter_details_args.dart';
import 'package:foe_archiving/presentation/shared/bloc/common_data_cubit.dart';
import 'package:foe_archiving/presentation/shared/widgets/animation_dialog.dart';
import 'package:lottie/lottie.dart';

import '../../../core/di/service_locator.dart';
import '../../../core/routing/routes.dart';
import '../../../core/theming/color_manager.dart';
import '../../../core/theming/font_manager.dart';
import '../../../core/theming/values_manager.dart';

Widget pdfPreview(BuildContext context,PdfArgs args){
  return Container(
    constraints: const BoxConstraints(maxWidth: 200),
    padding: const EdgeInsets.symmetric(horizontal: AppSize.s6,vertical: AppSize.s12),
    margin: const EdgeInsets.symmetric(horizontal: AppSize.s6),
    decoration: BoxDecoration(
      border: Border.all(color: ColorManager.goldColor,width: 0.5,),
      borderRadius: const BorderRadius.all(Radius.circular(AppSize.s8)),
      color: Colors.transparent,
    ),
    child: Row(
      children: [
        Expanded(
          child: Text(args.pdf.name,
              style: TextStyle(color: Theme.of(context).primaryColorDark, overflow: TextOverflow.ellipsis,
                  fontFamily: FontConstants.family,fontSize: AppSize.s14,fontWeight: FontWeight.w600)),
        ),
        const SizedBox(width: AppSize.s8,),
        Icon(Icons.file_copy_outlined,size: AppSize.s16,color: Theme.of(context).primaryColorDark,),
      ],
    ),
  ).ripple(
        ()async {

          /*showDialog(
            context: context,
            builder: (BuildContext context) {
              return GiffyDialog.image(
                Image.asset(
                  "assets/animation/encrypt.gif",
                  height: 100,
                  fit: BoxFit.contain,
                ),
                backgroundColor: Theme.of(context).primaryColorLight,
              );
            },
          );*/
          /*scaleDialog(context, false, animationDialog(context,
              Center(
                child: Lottie.asset('assets/animation/encryption.json',
                    repeat: true,
                    width: 200,
                    height: 200,
                    fit: BoxFit.contain,),
              )));*/
          //await sl<CommonDataCubit>().encryptPDFInBackground("C:\\Users\\ElKas\\OneDrive\\Desktop\\test.pdf");
          //NotificationService.showNotification("TESTING TITLE", "HELLO WORLD !");
          //await sl<CommonDataCubit>().decryptPDFInBackground("C:\\Users\\ElKas\\OneDrive\\Documents\\encrypted_file.aes");

          // Dismiss loading animation
          //Navigator.pop(context);

          //PDFEncryptionService.encryptPDFInBackground(File("C:\\Users\\ElKas\\OneDrive\\Desktop\\test.pdf"));
          //PDFEncryptionService.decryptPDF();
      Navigator.of(context).pushNamed(Routes.pdfWeb,arguments: args);
    },
    borderRadius:
    BorderRadius.circular(AppSize.s8),
    overlayColor: MaterialStateColor.resolveWith(
            (states) => Theme.of(context).primaryColorDark.withOpacity(AppSize.s0_2)),
  );
 }