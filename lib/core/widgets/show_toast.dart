import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

void showMToast(BuildContext context, String message, TextStyle textStyle,
    Color background) {
  showToast(
    message,
    textStyle: textStyle,
    backgroundColor: background,
    context: context,
    position: StyledToastPosition.bottom,
    animDuration: const Duration(milliseconds: 500),
    duration: const Duration(milliseconds: 2500),
    animationBuilder: (
      BuildContext context,
      AnimationController controller,
      Duration duration,
      Widget child,
    ) {
      return SlideTransition(
        position: getAnimation<Offset>(
            const Offset(0.0, 3.0), const Offset(0, 0), controller,
            curve: Curves.bounceInOut),
        child: child,
      );
    },
    reverseAnimBuilder: (
      BuildContext context,
      AnimationController controller,
      Duration duration,
      Widget child,
    ) {
      return SlideTransition(
        position: (getAnimation<Offset>(
            const Offset(0.0, 0.0), const Offset(-3.0, 0), controller,
            curve: Curves.easeInOut)),
        child: child,
      );
    },
  );
}
