import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:fin_tracker/features/login/presentation/screen/login_screen.dart';
import 'package:fin_tracker/features/dashboard/presentation/dashboard_screen.dart';
import 'package:fin_tracker/features/chat/presentation/ui/chat_screen.dart';
import '../../features/expense/presentation/screens/expense_list_screen.dart';
import '../../features/expense/presentation/screens/add_expense_screen.dart';
import 'app_routes.dart';

final appRouter = GoRouter(
  initialLocation: AppRoutes.rootPath,
  redirect: (context, state) {
    final user = FirebaseAuth.instance.currentUser;
    final isGoingToLogin = state.matchedLocation == AppRoutes.loginPath;
    final isGoingToRoot = state.matchedLocation == AppRoutes.rootPath;

    // If user is not authenticated and not going to login, redirect to login
    if (user == null && !isGoingToLogin) {
      return AppRoutes.loginPath;
    }

    // If user is authenticated and going to login or root, redirect to dashboard
    if (user != null && (isGoingToLogin || isGoingToRoot)) {
      return AppRoutes.dashboardPath;
    }

    // No redirect needed
    return null;
  },
  routes: [
    GoRoute(
      path: AppRoutes.rootPath,
      redirect: (context, state) => AppRoutes.loginPath,
    ),
    GoRoute(
      path: AppRoutes.loginPath,
      name: AppRoutes.loginName,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: AppRoutes.dashboardPath,
      name: AppRoutes.dashboardName,
      builder: (context, state) => const DashboardScreen(),
    ),
    GoRoute(
      path: AppRoutes.chatPath,
      name: AppRoutes.chatName,
      builder: (context, state) => const ChatScreen(),
    ),
    GoRoute(
      path: AppRoutes.expenseListPath,
      name: AppRoutes.expenseListName,
      builder: (context, state) => const ExpenseListScreen(),
    ),
    GoRoute(
      path: AppRoutes.addExpensePath,
      name: AppRoutes.addExpenseName,
      builder: (context, state) => const AddExpenseScreen(),
    ),
  ],
);
