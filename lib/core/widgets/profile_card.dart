import 'package:flutter/material.dart';
import '../widgets/glass_card.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class ProfileCard extends StatelessWidget {
  final String name;
  final String location;
  final String profession;
  final double rating;
  final String description;
  final IconData icon;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const ProfileCard({
    super.key,
    required this.name,
    required this.location,
    required this.profession,
    required this.rating,
    required this.description,
    required this.icon,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Avatar + Info
          Row(
            children: [
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 36,
                    backgroundColor: Colors.white.withValues(alpha: 0.1),
                    child: Icon(icon, size: 40, color: Colors.white),
                  ),
                  Container(
                    height: 14,
                    width: 14,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: AppTextStyles.cardTitle.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      location,
                      style: AppTextStyles.cardSub.copyWith(fontSize: 12),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          profession,
                          style: TextStyle(fontSize: 12, color: Colors.white70),
                        ),
                        const SizedBox(width: 6),
                        Icon(Icons.star, size: 12, color: Colors.amber),
                        const SizedBox(width: 4),
                        Text(
                          rating.toStringAsFixed(1),
                          style: TextStyle(fontSize: 12, color: Colors.white70),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Description
          Text(
            description,
            style: TextStyle(fontSize: 13, color: Colors.white70, height: 1.4),
          ),
          const SizedBox(height: 16),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: onEdit ?? () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 11),
                  ),
                  child: const Text(
                    'Edit Service',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.notReady.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.notReady, width: 0.5),
                ),
                child: IconButton(
                  onPressed: onDelete ?? () {},
                  icon: Icon(
                    Icons.delete_outline,
                    color: AppColors.notReady,
                    size: 18,
                  ),
                  padding: EdgeInsets.all(12),
                  constraints: BoxConstraints(minWidth: 44, minHeight: 44),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
