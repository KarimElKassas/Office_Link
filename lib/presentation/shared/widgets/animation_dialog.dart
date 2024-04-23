import 'package:flutter/material.dart';

import '../../../core/theming/values_manager.dart';

Widget animationDialog(BuildContext context,Widget content) {
  return AlertDialog(
      backgroundColor: Theme.of(context).primaryColorLight,
      contentPadding: const EdgeInsets.all(AppSize.s16),
      content: content);
}
