import 'dart:async';

import 'package:flutter/material.dart';

import 'app/app_dependencies.dart';
import 'ui/core/theme/app_theme.dart';
import 'ui/core/view_models/app_view_model.dart';
import 'ui/features/home/views/project_shell.dart';

void main() {
  runApp(const BuscaminasApp());
}

class BuscaminasApp extends StatefulWidget {
  const BuscaminasApp({super.key, this.dependencies});

  final AppDependencies? dependencies;

  static const String title = ProjectShell.title;

  @override
  State<BuscaminasApp> createState() => _BuscaminasAppState();
}

class _BuscaminasAppState extends State<BuscaminasApp> {
  late final AppDependencies _dependencies;
  late final AppViewModel _appViewModel;

  @override
  void initState() {
    super.initState();
    _dependencies = widget.dependencies ?? AppDependencies.memory();
    _appViewModel = _dependencies.createAppViewModel();
    unawaited(_appViewModel.load());
  }

  @override
  void dispose() {
    _appViewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppDependenciesScope(
      dependencies: _dependencies,
      child: ListenableBuilder(
        listenable: _appViewModel,
        builder: (context, _) {
          return MaterialApp(
            title: BuscaminasApp.title,
            debugShowCheckedModeBanner: false,
            themeMode: _appViewModel.themeMode,
            theme: AppTheme.light(),
            darkTheme: AppTheme.dark(),
            home: ProjectShell(appViewModel: _appViewModel),
          );
        },
      ),
    );
  }
}
