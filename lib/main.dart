import 'package:flutter/material.dart';
import 'package:projeto_final_flutter/core/routing/app_routes.dart';
import 'package:projeto_final_flutter/core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Candidate App',
      theme: AppTheme.light,
      routerConfig: appRouter,
    );
  }
}
