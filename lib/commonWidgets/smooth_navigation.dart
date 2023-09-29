import 'package:flutter/material.dart';

class SmoothSlidePageRoute extends PageRouteBuilder {
  final Widget page;

  SmoothSlidePageRoute({required this.page})
      : super(
          transitionDuration: const Duration(
              milliseconds: 500), // Adjust the duration as needed
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            var curve =
                Curves.easeInOut; // Use an easeInOut curve for smoothness
            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            // Wrap the child in an AnimatedBuilder for smoother animation
            return AnimatedBuilder(
              animation: animation,
              builder: (context, child) {
                return SlideTransition(
                  position: tween.animate(animation),
                  child: child,
                );
              },
              child: child,
            );
          },
        );
}
