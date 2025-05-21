import 'package:flutter/material.dart';
import '../features/authentication/views/login_screen.dart';
import '../features/menu/views/menu_screen.dart';
import '../features/create_project/views/create_project_screen.dart';
import '../features/project_lists/views/project_lists_screen.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/login': (context) => LoginScreen(),
  '/menu': (context) => MenuScreen(),
  '/create_project': (context) => CreateProjectScreen(),
  '/ranking': (context) => const RankingProjectListScreen(),
};