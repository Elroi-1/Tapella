import 'package:flutter/material.dart';
import 'package:tapella/core/widgets/profile_avatar.dart';
import '../widgets/glass_card.dart';
import 'package:intl/intl.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class NewJob extends StatelessWidget {
  final String name;
  final String? profileImage;
  final String status;
  final String proffession;
  final DateTime dateTime;
  final String location;
  final String category;
  final VoidCallback? onComplete;
  final VoidCallback? onDelete;
  final VoidCallback? onAccept;
  final VoidCallback? onReject;

  const NewJob({
    super.key,
    required this.name,
    this.profileImage,
    required this.status,
    required this.proffession,
    required this.dateTime,
    required this.location,
    required this.category,
    this.onComplete,
    this.onDelete,
    this.onAccept,
    this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Container(
        padding: EdgeInsets.all(14),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    ProfileAvatar(profileImageBase64: profileImage, size: 64),
                    Container(
                      height: 16,
                      width: 16,
                      decoration: BoxDecoration(
                        color: _getStatusColor(status),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.requestBoxDecorationBorder,
                          width: 2.5,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: AppTextStyles.cardTitle),
                      const SizedBox(width: 8),
                      Text("Professional"),
                      Text(proffession, style: AppTextStyles.cardSub),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                _statusCheck(status),
              ],
            ),

            const SizedBox(height: 24),

            Column(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 16,
                      color: AppColors.iconColor,
                      weight: 2,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _formatDateTime(dateTime),
                      style: AppTextStyles.cardSub,
                    ),
                  ],
                ),
                const SizedBox(height: 18),

                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 16,
                      color: AppColors.iconColor,
                      weight: 2,
                    ),
                    const SizedBox(width: 8),
                    Text(location, style: AppTextStyles.cardSub),
                  ],
                ),
              ],
            ),
            SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(top: 18.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: onAccept,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 12,
                      ),
                    ),
                    child: const Text(
                      "Accept",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: onReject,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 12,
                      ),
                    ),
                    child: const Text(
                      "Reject",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _formatDateTime(DateTime dateTime) {
  final DateFormat formatter = DateFormat('MMMM dd, yyyy • hh:mm a');
  return formatter.format(dateTime);
}

Color _getStatusColor(String status) {
  if (status == 'accepted' || status == 'completed') {
    return AppColors.successBright;
  }
  if (status == 'pending') return AppColors.warning;
  return AppColors.notReady;
}

Widget _statusCheck(String status) {
  final color = _getStatusColor(status);
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: color, width: 0.5),
    ),
    child: Text(
      (status == 'completed' ? 'DONE' : status).toUpperCase(),
      style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 11),
    ),
  );
}
