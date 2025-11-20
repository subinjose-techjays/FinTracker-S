import 'package:go_router/go_router.dart';
import 'package:fin_tracker/features/login/presentation/screen/login_screen.dart';
import 'package:fin_tracker/features/dashboard/presentation/dashboard_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/dashboard',
      name: 'dashboard',
      builder: (context, state) => const DashboardScreen(),
    ),
  ],
);
