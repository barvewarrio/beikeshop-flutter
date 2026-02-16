import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Container(
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            const Icon(Icons.search, color: AppColors.textHint, size: 20),
            const SizedBox(width: 8),
            Text(
              'Search "running shoes"',
              style: TextStyle(
                color: AppColors.textHint,
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(
            Icons.camera_alt_outlined,
            color: AppColors.textPrimary,
          ),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(
            Icons.notifications_none,
            color: AppColors.textPrimary,
          ),
          onPressed: () {},
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
