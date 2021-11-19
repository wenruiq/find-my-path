import 'package:flutter/material.dart';

//* This file is to change the transition animation
//TODO: use this if applicable

class SlideRoute extends PageRouteBuilder {
  final Widget page;
  // final String routeName = '/';

  SlideRoute({required this.page, required String routeName})
      : super(
          settings: RouteSettings(name: routeName),
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              FadeTransition(opacity: animation, child: child),
          transitionDuration: Duration(milliseconds: 500),
        );
}
