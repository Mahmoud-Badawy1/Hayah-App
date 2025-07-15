import 'package:flutter/material.dart';

class AppAnimations {
  static Duration get defaultDuration => const Duration(milliseconds: 300);
  static Duration get longDuration => const Duration(milliseconds: 500);
  static Duration get quickDuration => const Duration(milliseconds: 200);

  static Curve get defaultCurve => Curves.easeInOut;
  static Curve get bounceCurve => Curves.elasticOut;
  static Curve get smoothCurve => Curves.fastOutSlowIn;

  static Widget fadeIn({
    required Widget child,
    Duration? duration,
    Curve? curve,
  }) {
    return FadeTransition(
      opacity: CurvedAnimation(
        parent: const AlwaysStoppedAnimation(1.0),
        curve: curve ?? defaultCurve,
      ),
      child: child,
    );
  }

  static Widget slideIn({
    required Widget child,
    Duration? duration,
    Curve? curve,
    Offset? beginOffset,
  }) {
    return SlideTransition(
      position:
          Tween<Offset>(
            begin: beginOffset ?? const Offset(0, 0.1),
            end: Offset.zero,
          ).animate(
            CurvedAnimation(
              parent: const AlwaysStoppedAnimation(1.0),
              curve: curve ?? defaultCurve,
            ),
          ),
      child: child,
    );
  }

  static PageRouteBuilder<T> pageRoute<T>({
    required Widget page,
    RouteSettings? settings,
    Duration? duration,
    Curve? curve,
  }) {
    return PageRouteBuilder<T>(
      settings: settings,
      transitionDuration: duration ?? defaultDuration,
      reverseTransitionDuration: duration ?? defaultDuration,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: curve ?? smoothCurve,
        );

        return FadeTransition(
          opacity: curvedAnimation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.1),
              end: Offset.zero,
            ).animate(curvedAnimation),
            child: child,
          ),
        );
      },
    );
  }
}
