import 'package:flutter/material.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text("Ardl"),
      elevation: 10,
      actions: [
        // IconButton(
        //   icon: const Icon(Icons.settings),
        //   onPressed: () => Navigator.push(
        //     context,
        //     MaterialPageRoute(builder: (context) => const SettingsPage()),
        //   ),
        // ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
