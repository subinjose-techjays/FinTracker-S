import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:fin_tracker/features/login/presentation/screen/login_screen.dart';
import 'package:fin_tracker/features/dashboard/presentation/dashboard_screen.dart';
import 'package:fin_tracker/features/chat/presentation/ui/chat_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  redirect: (context, state) {
    final user = FirebaseAuth.instance.currentUser;
    final isGoingToLogin = state.matchedLocation == '/login';
    final isGoingToRoot = state.matchedLocation == '/';

    // If user is not authenticated and not going to login, redirect to login
    if (user == null && !isGoingToLogin) {
      return '/login';
    }

    // If user is authenticated and going to login or root, redirect to dashboard
    if (user != null && (isGoingToLogin || isGoingToRoot)) {
      return '/dashboard';
    }

    // No redirect needed
    return null;
  },
  routes: [
    GoRoute(path: '/', redirect: (context, state) => '/login'),
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
    GoRoute(
      path: '/chat',
      name: 'chat',
      builder: (context, state) => const ChatScreen(),
    ),
  ],
);
