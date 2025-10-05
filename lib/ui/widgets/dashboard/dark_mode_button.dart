import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:insulin/providers/theme_provider.dart';

class DarkModeButton extends StatelessWidget {
  const DarkModeButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Consumer<ThemeProvider>(
      builder:  (context, themeProvider, child) {
          return IconButton(
            onPressed: themeProvider.toggleTheme,
            icon: themeProvider.isDarkMode
            ? const Icon(Icons.light_mode)
            : const Icon(Icons.dark_mode),
          );
        }
      ),
    );
  }
}
