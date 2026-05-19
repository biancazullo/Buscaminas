import 'package:flutter/material.dart';

import '../../../core/view_models/app_view_model.dart';
import 'main_menu_view.dart';
import 'splash_view.dart';

class ProjectShell extends StatefulWidget {
  const ProjectShell({super.key, required this.appViewModel});

  final AppViewModel appViewModel;

  static const String title = 'Buscaminas Flutter';

  @override
  State<ProjectShell> createState() => _ProjectShellState();
}

class _ProjectShellState extends State<ProjectShell> {
  bool _showSplash = true;

  void _showMainMenu() {
    if (!_showSplash || !mounted) {
      return;
    }

    setState(() => _showSplash = false);
  }

  @override
  Widget build(BuildContext context) {
    final animationsEnabled = widget.appViewModel.settings.animationsEnabled;

    return AnimatedSwitcher(
      duration: animationsEnabled
          ? const Duration(milliseconds: 350)
          : Duration.zero,
      child: _showSplash
          ? SplashView(
              key: const ValueKey('splash-view'),
              animationsEnabled: animationsEnabled,
              onFinished: _showMainMenu,
            )
          : MainMenuView(
              key: const ValueKey('main-menu-view'),
              animationsEnabled: animationsEnabled,
            ),
    );
  }
}
