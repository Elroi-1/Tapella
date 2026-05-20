import 'package:flutter/material.dart';
import 'package:tapella/core/theme/app_colors.dart';
import 'package:tapella/core/theme/app_text_styles.dart';

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool expand;
  final int height;
  final int width;
  final bool border;
  final Color fill;
  final Color? borderColor;
  final bool isLoading;

  const PrimaryButton({
    super.key,
    required this.label,
    required this.height,
    required this.width,
    required this.fill,
    this.border = false,
    this.borderColor,
    this.onPressed,
    this.icon,
    this.expand = true,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final background = fill;
    final borderColor = border
        ? (this.borderColor ?? AppColors.primaryTint)
        : Colors.transparent;

    final button = SizedBox(
      height: height.toDouble(),
      // width: width.toDouble(),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(9999),
          border: Border.all(color: borderColor),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isLoading ? null : onPressed,
            customBorder: const StadiumBorder(),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
              child: Center(
                child: isLoading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(label, style: AppTextStyles.button),
              ),
            ),
          ),
        ),
      ),
    );

    return button;
  }
}
