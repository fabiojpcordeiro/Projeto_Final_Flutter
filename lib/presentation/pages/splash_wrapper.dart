import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:projeto_final_flutter/core/storage/local_storage.dart';

class SplashWrapper extends StatefulWidget {
  const SplashWrapper({super.key});
  @override
  State<SplashWrapper> createState() => _SplashWrapperState();
}

class _SplashWrapperState extends State<SplashWrapper> {
  @override
  void initState() {
    super.initState();
    _initApp();
  }

  Future<void> _initApp() async {
    await Future.delayed(const Duration(milliseconds: 200));
    String? city = await LocalStorage.getCity() ?? '';

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.go('/home', extra: {'city': city});
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
