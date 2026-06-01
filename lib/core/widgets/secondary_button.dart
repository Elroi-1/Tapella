import 'package:flutter/material.dart';
import 'package:tapella/core/theme/app_colors.dart';
import 'package:tapella/core/theme/app_text_styles.dart';

class SecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool expand;

  const SecondaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.expand = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDisabled = onPressed == null;
    final borderColor = isDisabled
        ? AppColors.primaryTint.withValues(alpha: 0.5)
        : AppColors.primaryTint;
    final textColor = isDisabled
        ? AppColors.primaryTint.withValues(alpha: 0.5)
        : AppColors.primaryTint;

    final button = SizedBox(
      height: 54,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(9999),
          border: Border.all(color: borderColor),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            splashFactory: InkRipple.splashFactory,
            onTap: onPressed,
            customBorder: const StadiumBorder(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (icon != null) ...[
                      Icon(icon, size: 18, color: textColor),
                      const SizedBox(width: 8),
                    ],
                    Text(
                      label,
                      style: AppTextStyles.button.copyWith(color: textColor),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );

    if (!expand) {
      return button;
    }

    return SizedBox(width: double.infinity, child: button);
  }
}
