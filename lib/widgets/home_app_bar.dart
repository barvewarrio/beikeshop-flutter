import 'package:flutter/material.dart';
import 'package:beikeshop_flutter/l10n/app_localizations.dart';
import '../screens/search/search_screen.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SearchScreen()),
          );
        },
        child: Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey[300]!, width: 0.5),
          ),
          child: Row(
            children: [
              const Icon(Icons.search, color: Colors.black54, size: 22),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  l10n.searchHint,
                  style: const TextStyle(
                    color: Colors.black38,
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Icon(Icons.camera_alt_outlined, color: Colors.black54, size: 22),
            ],
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(
            Icons.mail_outline,
            color: Colors.black87,
            size: 26,
          ),
          onPressed: () {},
        ),
        const SizedBox(width: 4),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
