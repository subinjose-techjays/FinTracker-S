import 'package:fin_tracker/core/routes/app_routes.dart';
import 'package:fin_tracker/core/theme/app_colors.dart';
import 'package:fin_tracker/features/dashboard/di/dashboard_provider.dart';
import 'package:fin_tracker/features/expense/presentation/screens/add_expense_screen.dart';
import 'package:fin_tracker/features/expense/presentation/screens/expense_list_screen.dart';
import 'package:fin_tracker/features/profile/presentation/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  static const List<Widget> _pages = [
    ExpenseListScreen(),
    AddExpenseScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(dashboardIndexProvider);

    return Scaffold(
      body: IndexedStack(index: selectedIndex, children: _pages),
      floatingActionButton: FloatingActionButton(
        heroTag: 'dashboard_fab',
        onPressed: () => context.push(AppRoutes.chatPath),
        backgroundColor: AppColors.deepGreen,
        child: const Icon(Icons.chat, color: AppColors.white),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Expenses'),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            label: 'Add Expense',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: selectedIndex,
        selectedItemColor: AppColors.deepGreen,
        unselectedItemColor: Colors.grey,
        onTap: (index) =>
            ref.read(dashboardIndexProvider.notifier).state = index,
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.white,
        elevation: 8,
      ),
    );
  }
}
