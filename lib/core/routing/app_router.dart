import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:foe_archiving/core/routing/routes.dart';
import 'package:foe_archiving/presentation/features/archived_letters/all_archived/ui/all_archived_letters_screen.dart';
import 'package:foe_archiving/presentation/features/external_letter_details/ui/external_letter_details_screen.dart';
import 'package:foe_archiving/presentation/features/files_and_contracts/all_files_and_contracts/ui/all_files_and_contracts_screen.dart';
import 'package:foe_archiving/presentation/features/files_and_contracts/file_and_contract_details/ui/file_and_contract_details_screen.dart';
import 'package:foe_archiving/presentation/features/files_and_contracts/new_file_and_contract/ui/new_file_and_contract_screen.dart';
import 'package:foe_archiving/presentation/features/income_letters/external/ui/income_external_letters_screen.dart';
import 'package:foe_archiving/presentation/features/letter_details/ui/letter_details_screen.dart';
import 'package:foe_archiving/presentation/features/letter_reply/ui/letter_reply_screen.dart';
import 'package:foe_archiving/presentation/features/new_letter/ui/new_letter_screen.dart';
import 'package:foe_archiving/presentation/features/outgoing_letters/external/ui/outgoing_external_letters_screen.dart';
import 'package:foe_archiving/presentation/features/outgoing_letters/internal/ui/outgoing_internal_letters_screen.dart';
import 'package:foe_archiving/presentation/shared/ui/pdf_viewer.dart';

import '../../data/models/letter_model.dart';
import '../../presentation/features/archived_letters/archived_letter_details/ui/archived_letter_details_screen.dart';
import '../../presentation/features/letter_details/helper/letter_details_args.dart';
import '../../presentation/shared/ui/home_screen.dart';
import '../../presentation/features/login/ui/login_screen.dart';
import '../../presentation/features/splash/ui/splash_screen.dart';
import '../localization/strings_manager.dart';

class AppRouter{
  static Route<dynamic> getRoute(RouteSettings settings){
    final args = settings.arguments;
    switch (settings.name){
      case Routes.splashRoute :
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case Routes.loginRoute :
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case Routes.archiveHomeRoute :
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case Routes.newLetterRoute :
        return MaterialPageRoute(builder: (_) => NewLetterScreen());
      case Routes.newArchivedLetterRoute :
        return MaterialPageRoute(builder: (_) => NewFileAndContractScreen());
        case Routes.outgoingInternalLettersRoute :
        return MaterialPageRoute(builder: (_) => const OutgoingInternalLettersScreen());
      case Routes.allArchivedLettersRoute :
        return MaterialPageRoute(builder: (_) => const AllArchivedLettersScreen());
      case Routes.allFilesAndContractsRoute :
        return MaterialPageRoute(builder: (_) => const AllFilesAndContractsScreen());
      case Routes.incomeExternalRoute :
        return MaterialPageRoute(builder: (_) => const IncomeExternalLettersScreen());
      case Routes.outgoingExternalRoute :
        return MaterialPageRoute(builder: (_) => const OutgoingExternalLettersScreen());
      case Routes.letterDetailsRoute :
        LetterDetailsArgs arguments = args! as LetterDetailsArgs;
        return MaterialPageRoute(builder: (_) => LetterDetailsScreen(letterModel: arguments.letterModel, fromReplyScreen: arguments.openedFromReply,));
      case Routes.externalLetterDetailsRoute :
        LetterDetailsArgs arguments = args! as LetterDetailsArgs;
        return MaterialPageRoute(builder: (_) => ExternalLetterDetailsScreen(letterModel: arguments.letterModel, fromReplyScreen: arguments.openedFromReply,));
      case Routes.archivedLetterDetailsRoute :
        LetterDetailsArgs arguments = args! as LetterDetailsArgs;
        return MaterialPageRoute(builder: (_) => ArchivedLetterDetailsScreen(letterModel: arguments.letterModel));
      case Routes.contractDetailsRoute :
        LetterDetailsArgs arguments = args! as LetterDetailsArgs;
        return MaterialPageRoute(builder: (_) => FileAndContractDetailsScreen(letterModel: arguments.letterModel));
      case Routes.letterReplyRoute :
        return MaterialPageRoute(builder: (_) => LetterReplyScreen(letterModel: args as LetterModel));
      case Routes.pdfWeb :
        PdfArgs arguments = args! as PdfArgs;
        return MaterialPageRoute(builder: (_) => PdfWebView(pdf: arguments.pdf,index: arguments.index,));
      /*case Routes.archiveSecretaryHomeRoute :
        return MaterialPageRoute(builder: (_) => const SecretaryHomeScreen());
      case Routes.letterDetailsRoute :
        LetterDetailsArgs arguments = args! as LetterDetailsArgs;
        return MaterialPageRoute(builder: (_) => LetterDetailsScreen(letterModel: arguments.letterModel, letterType: arguments.letterType, fromReplyScreen: arguments.openedFromReply,));
      case Routes.letterReplyRoute :
        return MaterialPageRoute(builder: (_) => LetterReplyScreen(letterModel: args as LetterModel,));
      case Routes.updateLetterRoute :
        UpdateLetterArgs arguments = args! as UpdateLetterArgs;
        return MaterialPageRoute(builder: (_) => UpdateLetterScreen(letterModel: arguments.letterModel, letterFiles: arguments.letterFiles,selectedActionList: arguments.selectedActionList,selectedKnowList: arguments.selectedKnowList,));*/
      default:
        return unDefinedRoute();
    }
  }
  static Route<dynamic> unDefinedRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(title: Text(AppStrings.noRouteFound.tr()),),
        body: Center(child: Text(AppStrings.noRouteFound.tr()),),
      );
    });
  }
}