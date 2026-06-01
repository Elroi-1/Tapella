import 'package:flutter/material.dart';
import 'package:tapella/core/widgets/mini_text_field.dart';
import 'package:tapella/core/widgets/profile_avatar.dart';
import '../widgets/glass_card.dart';
import 'package:intl/intl.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class BusinessReqCard extends StatefulWidget {
  final String name;
  final String? profileImage;
  final String status;
  final String proffession;
  final DateTime dateTime;
  final String location;
  final String category;
  final Function(double?)? onComplete;
  final VoidCallback? onDelete;
  final double? money;

  const BusinessReqCard({
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
    this.money,
  });

  @override
  State<BusinessReqCard> createState() => _BusinessReqCardState();
}

class _BusinessReqCardState extends State<BusinessReqCard> {
  final TextEditingController _earningsController = TextEditingController();

  @override
  void dispose() {
    _earningsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Container(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    ProfileAvatar(
                      profileImageBase64: widget.profileImage,
                      size: 64,
                    ),
                    Container(
                      height: 16,
                      width: 16,
                      decoration: BoxDecoration(
                        color: _getStatusColor(widget.status),
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
                      Text(widget.name, style: AppTextStyles.cardTitle),
                      const SizedBox(width: 8),
                      const Text("Professional"),
                      Text(widget.proffession, style: AppTextStyles.cardSub),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                _statusCheck(widget.status),
              ],
            ),
            const SizedBox(height: 24),
            Column(
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      size: 16,
                      color: AppColors.iconColor,
                      weight: 2,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _formatDateTime(widget.dateTime),
                      style: AppTextStyles.cardSub,
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 16,
                      color: AppColors.iconColor,
                      weight: 2,
                    ),
                    const SizedBox(width: 8),
                    Text(widget.location, style: AppTextStyles.cardSub),
                  ],
                ),
              ],
            ),
            if (widget.status == 'accepted') ...[
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  width: 140,
                  child: MiniTextField(
                    label: 'Earnings',
                    hintText: 'ETB',
                    prefixIcon: Icons.attach_money_outlined,
                    controller: _earningsController,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 18.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        final amount = double.tryParse(
                          _earningsController.text,
                        );
                        widget.onComplete?.call(amount);
                      },
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
                        "Finish Job",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    InkWell(
                      onTap: widget.onDelete,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.notReady.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppColors.notReady, // outline color
                            width: 0.5, // thickness
                          ),
                        ),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.delete_outline,
                              color: AppColors.notReady,
                              size: 16,
                              weight: 2,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ] else ...[
              if (widget.money != null && widget.status == 'completed') ...[
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Icon(
                      Icons.attach_money,
                      size: 18,
                      color: AppColors.successBright,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Earnings: ETB ${widget.money!.toStringAsFixed(0)}',
                      style: AppTextStyles.cardSub.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ],
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
