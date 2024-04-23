import 'package:flutter/material.dart';

void scaleDialog(BuildContext context, bool dismissible, Widget content) {
  showGeneralDialog(
    barrierLabel: '',
    barrierDismissible: dismissible,
    barrierColor: Colors.black.withOpacity(0.2),
    context: context,
    pageBuilder: (ctx, a1, a2) {
      return Container();
    },
    transitionBuilder: (ctx, a1, a2, child) {
      var curve = Curves.easeInOut.transform(a1.value);
      return Transform.scale(
        scale: curve,
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: content,
        ),
      );
    },
    transitionDuration: const Duration(milliseconds: 300),
  );
}