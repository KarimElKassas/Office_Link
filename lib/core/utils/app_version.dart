import 'dart:io';
import 'dart:math';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:foe_archiving/core/utils/prefs_helper.dart';

class Constants {
  static String latestVersion = "1.0.9.0";
  static int latestVersionNumber = 1090;
  static int currentVersionNumber = 1090;
  static double currentVersion = 1.9;
  static AdaptiveThemeMode? currentTheme = AdaptiveThemeMode.dark;
  static String? currentLocale = 'ar';

  static Guid adminRoleId = Guid('dffa052f-b4af-4b68-b83d-24d0d5ae3fa2');
  static Guid secretaryRoleId = Guid('a6865179-6fc1-4b50-8062-97dbbcdb0973');
  static Guid allMembersRoleId = Guid('44a5fc3f-4ec7-4a91-b1e7-93488fc53cd8');
  static Guid additionalDateGuid = Guid('83e6687b-48ed-41b5-b42e-59d3fb264d81');
  static Guid additionalTextGuid = Guid('9dcf9de1-f32b-4da7-be08-a665cfa954c9');
  static Guid acceptedLetterStateGuid = Guid('fe703ab5-2016-4d6f-9e40-145cb3f0264f');

  // Security Levels
  static Guid topSecretGuid = Guid('9b572ec8-72bd-4216-b8f8-8769b5292931');
  static Guid secretGuid = Guid('493c9175-2937-4cbb-92a1-84cafb6aec0c');
  static Guid publicSecretGuid = Guid('a5bcbcd0-5376-41cb-99fe-50967d9e55c3');

  // Files Shared Path
  static String sharePath = "\\\\192.168.2.50\\ArchiveLetters";

}
Future<bool> checkForUpdate()async{
  List<int> versions = [];
  Directory directory =  Directory(r"\\172.16.9.43\System\Archiving\versions");
  directory.listSync(recursive: false).forEach((element) {
    var fileName = element.path.replaceAll(r"\", "/").split("/").last.split("foe_archiving_").last.split(".msix").first.replaceAll(".", "");
    print("FILE NAME : $fileName");
    versions.add(int.parse(fileName));
  });
  Constants.latestVersionNumber = versions.reduce(max);
  Constants.latestVersion = Constants.latestVersionNumber.toString().trim().replaceAllMapped(RegExp(r".{1}"), (match) => "${match.group(0)}.");
  Constants.latestVersion = Constants.latestVersion.substring(0, Constants.latestVersion.length - 1);
  print("LATEST : ${Constants.latestVersionNumber}\nLATEST : ${Constants.latestVersion}\n CURRENT : ${Constants.currentVersionNumber}\n");
  return Constants.currentVersionNumber < Constants.latestVersionNumber;
}

String sessionToken = Preference.prefs.getString('sessionToken')!;

bool isDialogShowing(BuildContext context) {
  bool isShowing = false;
  Navigator.of(context).popUntil((route) {
    if (route.isCurrent && route.settings.name == '/loadingDialog') {
      isShowing = true;
      return true;
    }
    return false;
  });
  return isShowing;
}
