import 'package:flutter/material.dart';

class GameCard extends StatelessWidget {
  final String title;
  final String? imagePath;
  final IconData? placeholderIcon;
  final Color backgroundColor;
  final VoidCallback onTap;

  const GameCard({
    super.key,
    required this.title,
    this.imagePath,
    this.placeholderIcon,
    required this.backgroundColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 18),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: imagePath != null
                  ? Image.asset(
                      imagePath!,
                      width: 140,
                      height: 100,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          _buildPlaceholder(),
                    )
                  : _buildPlaceholder(),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4A4A4A),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      width: 140,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.4),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Icon(
        placeholderIcon ?? Icons.auto_stories_rounded,
        size: 48,
        color: Colors.white,
      ),
    );
  }
}
