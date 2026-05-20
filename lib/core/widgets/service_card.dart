import 'package:flutter/material.dart';
import '../widgets/glass_card.dart';
import '../widgets/profile_avatar.dart';

class ServiceCard extends StatelessWidget {
  final String name;
  final String? profileImage;
  final String location;
  final String role;
  final double rating;
  final String description;
  final String? phone;
  final bool isSaved;
  final VoidCallback onSaveToggle;
  final VoidCallback onBookNow;
  final VoidCallback? onCall;
  final VoidCallback? onCardTap;

  const ServiceCard({
    super.key,
    required this.name,
    this.profileImage,
    required this.location,
    required this.role,
    required this.rating,
    required this.description,
    this.phone,
    required this.isSaved,
    required this.onSaveToggle,
    required this.onBookNow,
    this.onCall,
    this.onCardTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onCardTap,
      child: GlassCard(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ProfileAvatar(profileImageBase64: profileImage, size: 64),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          color: Color(0xFFDAE2FD),
                          fontSize: 18,
                          fontWeight: FontWeight.normal,
                          fontFamily: 'manrope',
                          height: 28 / 18,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined, size: 14, color: Color(0xFFC1C6D7)),
                          const SizedBox(width: 4),
                          Text(location, style: const TextStyle(color: Color(0xFFC1C6D7))),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text('$role •', style: const TextStyle(color: Color(0xFFC1C6D7), fontSize: 14)),
                          const SizedBox(width: 8),
                          const Icon(Icons.star, color: Colors.amberAccent, size: 16),
                          const SizedBox(width: 5),
                          Text('$rating', style: const TextStyle(color: Colors.white70)),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: onSaveToggle,
                  icon: Icon(
                    isSaved ? Icons.bookmark : Icons.bookmark_border,
                    color: isSaved ? Colors.blue : Colors.blueAccent,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Text(description, style: const TextStyle(color: Colors.grey, fontSize: 14)),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: onBookNow,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFA6C8FF),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  ),
                  child: const Text('Book Now', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                if (onCall != null)
                  InkWell(
                    onTap: onCall,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF007AFF).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFF007AFF), width: 0.5),
                      ),
                      child: const Icon(Icons.phone_in_talk_outlined, color: Color(0xFF007AFF), size: 16),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
