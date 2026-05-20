import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import "../routing/app_router.dart";
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget leading;
  final List<Widget>? actions;
  final VoidCallback? onMenuPressed;

  const CustomAppBar({
    super.key,
    this.title = 'TAPELLA',
    this.leading = const Icon(Icons.menu_rounded),
    this.actions,
    this.onMenuPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      backgroundColor: AppColors.background,
      elevation: 0,
      centerTitle: false,
      titleSpacing: 0,
      title: Text(title, style: AppTextStyles.appBarTitle),
      leading: IconButton(
        icon: leading,
        onPressed: onMenuPressed ?? () => Scaffold.of(context).openDrawer(),
      ),
      actions: actions,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(2),
        child: Container(
          height: 1,
          decoration: BoxDecoration(gradient: AppColors.grad),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
