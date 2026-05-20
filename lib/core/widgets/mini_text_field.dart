import 'package:flutter/material.dart';
import 'package:tapella/core/theme/app_text_styles.dart';
import '../theme/app_colors.dart';

class MiniTextField extends StatelessWidget {
  final String label;
  final String hintText;
  final IconData? prefixIcon;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;

  const MiniTextField({
    super.key,
    required this.label,
    required this.hintText,
    this.prefixIcon,
    this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.providerCard),
        const SizedBox(height: 6),
        SizedBox(
          height: 40,
          child: TextField(
            controller: controller,
            onChanged: onChanged,
            style: TextStyle(fontSize: 13, color: Colors.white),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(fontSize: 12, color: Colors.white38),
              prefixIcon: prefixIcon != null
                  ? Icon(prefixIcon, size: 16, color: Colors.white54)
                  : null,
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.white24, width: 0.5),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.white24, width: 0.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppColors.primaryBlue, width: 1),
              ),
              filled: true,
              fillColor: Colors.white.withValues(alpha: 0.05),
            ),
          ),
        ),
      ],
    );
  }
}
