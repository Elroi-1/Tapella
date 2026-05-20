import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:tapella/core/theme/app_colors.dart';
import 'package:tapella/core/widgets/app_drawer.dart';

class AppScaffold extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget body;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final Widget? drawer;
  final EdgeInsetsGeometry padding;
  final bool extendBodyBehindAppBar;
  final bool extendBody;
  final double blurSigma;
  final Gradient? backgroundGradient;

  const AppScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.drawer,
    this.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    this.extendBodyBehindAppBar = false,
    this.extendBody = false,
    this.blurSigma = 12,
    this.backgroundGradient,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: appBar,
      drawer: drawer ?? const AppDrawer(),
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      extendBody: extendBody,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.background,
              gradient: backgroundGradient,
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
              child: Container(
                color: AppColors.background.withValues(alpha: 0.25),
              ),
            ),
          ),
          SafeArea(
            top: appBar == null,
            child: Padding(padding: padding, child: body),
          ),
        ],
      ),
    );
  }
}
