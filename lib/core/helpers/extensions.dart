import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:foe_archiving/core/theming/color_manager.dart';

import '../theming/values_manager.dart';

extension Navigation on BuildContext {
  Future<dynamic> pushNamed(String routeName, {Object? arguments}) {
    return Navigator.of(this).pushNamed(routeName, arguments: arguments);
  }

  Future<dynamic> pushReplacementNamed(String routeName, {Object? arguments}) {
    return Navigator.of(this)
        .pushReplacementNamed(routeName, arguments: arguments);
  }

  Future<dynamic> pushNamedAndRemoveUntil(String routeName,
      {Object? arguments, required RoutePredicate predicate}) {
    return Navigator.of(this)
        .pushNamedAndRemoveUntil(routeName, predicate, arguments: arguments);
  }

  void pop() => Navigator.of(this).pop();
}

extension OnPressed on Widget {
  Widget ripple(Function onPressed,
      {BorderRadiusGeometry borderRadius = const BorderRadius.all(Radius.circular(AppSize.s5)), MaterialStateProperty<Color>? overlayColor, double paddingTop = 0, double paddingBottom = 0,double paddingRight = 0, double paddingLeft = 0}) =>
      Stack(
        children: <Widget>[
          this,
          Positioned(
            left: paddingLeft,
            right: paddingRight,
            top: paddingTop,
            bottom: paddingBottom,
            child: TextButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(borderRadius: borderRadius),
                  ),
                  overlayColor: overlayColor ?? MaterialStateProperty.all(ColorManager.darkGreen.withOpacity(0.2)),
                ),
                onPressed: () {
                  onPressed();
                },
                child: Container()),
          )
        ],
      );
}