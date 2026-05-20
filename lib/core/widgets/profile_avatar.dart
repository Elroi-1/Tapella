import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tapella/core/theme/app_colors.dart';

class ProfileAvatar extends StatelessWidget {
  final String? profileImageBase64;
  final double size;
  final bool showEditBadge;
  final VoidCallback? onTap;
  final Color? borderColor;
  final double? borderWidth;

  const ProfileAvatar({
    super.key,
    this.profileImageBase64,
    this.size = 110,
    this.showEditBadge = false,
    this.onTap,
    this.borderColor,
    this.borderWidth,
  });

  @override
  Widget build(BuildContext context) {
    Widget avatar = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.profileCirclePurple,
        border: borderWidth != null
            ? Border.all(
                color: borderColor ?? AppColors.iconBorder,
                width: borderWidth!,
              )
            : null,
      ),
      clipBehavior: Clip.antiAlias,
      child: _buildImage(),
    );

    if (onTap != null) {
      avatar = GestureDetector(onTap: onTap, child: avatar);
    }

    if (!showEditBadge) return avatar;

    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        avatar,
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: AppColors.primaryBlue,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.background, width: 2),
            ),
            child: const Icon(Icons.camera_alt, size: 14, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildImage() {
    if (profileImageBase64 != null && profileImageBase64!.isNotEmpty) {
      try {
        return Image.memory(
          base64Decode(profileImageBase64!),
          fit: BoxFit.cover,
          width: size,
          height: size,
        );
      } catch (_) {
        /* fall through */
      }
    }
    return Icon(
      Icons.person_outline,
      size: size * 0.55,
      color: AppColors.profileIconP,
    );
  }
}

Future<String?> pickProfileImageBase64() async {
  final picker = ImagePicker();
  final file = await picker.pickImage(
    source: ImageSource.gallery,
    maxWidth: 512,
    maxHeight: 512,
    imageQuality: 75,
  );
  if (file == null) return null;
  final bytes = await file.readAsBytes();
  if (bytes.length > 900000) return null;
  return base64Encode(bytes);
}
