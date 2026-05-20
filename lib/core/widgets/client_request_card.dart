import 'package:flutter/material.dart';
import '../widgets/glass_card.dart';
import 'package:intl/intl.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../widgets/profile_avatar.dart';

class RequestCard extends StatelessWidget {
  final String name;
  final String? profileImage;
  final String status;
  final String proffession;
  final DateTime dateTime;
  final String location;
  final VoidCallback? onCancel;
  final VoidCallback? onTap;

  const RequestCard({
    super.key,
    required this.name,
    this.profileImage,
    required this.status,
    required this.proffession,
    required this.dateTime,
    required this.location,
    this.onCancel,
    this.onTap,
  });

  bool get _canCancel => status == 'pending';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: GlassCard(
        child: Container(
          padding: const EdgeInsets.all(14),
          child: Column(
            children: [
              Row(
                children: [
                  ProfileAvatar(profileImageBase64: profileImage, size: 64),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(name, style: AppTextStyles.cardTitle),
                        Text(proffession, style: AppTextStyles.cardSub),
                      ],
                    ),
                  ),
                  _statusCheck(status),
                ],
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  const Icon(Icons.calendar_today, size: 16, color: AppColors.iconColor),
                  const SizedBox(width: 8),
                  Text(_formatDateTime(dateTime), style: AppTextStyles.cardSub),
                ],
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  const Icon(Icons.location_on_outlined, size: 16, color: AppColors.iconColor),
                  const SizedBox(width: 8),
                  Text(location, style: AppTextStyles.cardSub),
                ],
              ),
              if (_canCancel)
                Padding(
                  padding: const EdgeInsets.only(top: 18),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: onCancel,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.notReady.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: AppColors.notReady, width: 0.5),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.delete_outline, color: AppColors.notReady, size: 16),
                              const SizedBox(width: 8),
                              Text('Cancel Request', style: AppTextStyles.notReady),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

String _formatDateTime(DateTime dateTime) {
  return DateFormat('MMMM dd, yyyy • hh:mm a').format(dateTime);
}

Widget _statusCheck(String status) {
  Color color;
  if (status == 'accepted' || status == 'completed') {
    color = AppColors.successBright;
  } else if (status == 'pending') {
    color = AppColors.warning;
  } else {
    color = AppColors.notReady;
  }
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: color, width: 0.5),
    ),
    child: Text(
      status.toUpperCase(),
      style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12),
    ),
  );
}
