import 'package:go_router/go_router.dart';
import 'package:projeto_final_flutter/presentation/pages/home_page.dart';
import 'package:projeto_final_flutter/presentation/pages/job_details_page.dart';
import 'package:projeto_final_flutter/presentation/pages/splash_wrapper.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (_, __) => const SplashWrapper()),
    GoRoute(
      path: '/home',
      builder: (_, state) {
        final extras = state.extra as Map<String, dynamic>?;
        final city = extras?['city'] as String?;
        //final jobs = extras[jobs] as List<Job>;
        return HomePage(city: city);
      },
    ),
    GoRoute(
      path: '/job-details/:id',
      builder: (context, state) {
        return JobDetailsPage(jobId: state.pathParameters['id']!);
      },
    ),
  ],
);
