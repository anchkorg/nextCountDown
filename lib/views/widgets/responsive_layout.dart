import 'package:flutter/material.dart';
//import 'package:responsive_framework/responsive_framework.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    return context
            .isMobile //ResponsiveBreakpoints.of(context).isMobile
        ? mobile
        : context
              .isTablet //ResponsiveBreakpoints.of(context).isTablet
        ? tablet ?? mobile
        : desktop ?? tablet ?? mobile;
  }
}

class AppBreakpoints {
  static const double mobile = 600;
  static const double tablet = 1024;
  static const double desktop = 1440;
}

extension ResponsiveContext on BuildContext {
  bool get isMobile => MediaQuery.of(this).size.width < AppBreakpoints.mobile;
  bool get isTablet =>
      MediaQuery.of(this).size.width >= AppBreakpoints.mobile &&
      MediaQuery.of(this).size.width < AppBreakpoints.tablet;
  bool get isDesktop => MediaQuery.of(this).size.width >= AppBreakpoints.tablet;

  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;
}
