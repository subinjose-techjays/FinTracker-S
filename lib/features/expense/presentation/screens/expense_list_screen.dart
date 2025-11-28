import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routes/app_routes.dart';

import '../../di/expense_module.dart';
import '../event/expense_event.dart';

class ExpenseListScreen extends ConsumerWidget {
  const ExpenseListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expenseState = ref.watch(expenseViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Expenses')),
      body: expenseState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : expenseState.error != null
          ? Center(child: Text('Error: ${expenseState.error}'))
          : expenseState.expenses.isEmpty
          ? const Center(child: Text('No expenses yet.'))
          : ListView.builder(
              itemCount: expenseState.expenses.length,
              itemBuilder: (context, index) {
                final expense = expenseState.expenses[index];
                return ListTile(
                  title: Text(expense.title),
                  subtitle: Text(
                    '${expense.category} - ${expense.date.toString().split(' ')[0]}',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '\$${expense.amount.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          ref
                              .read(expenseViewModelProvider.notifier)
                              .onEvent(DeleteExpenseEvent(expense.id));
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'expense_list_fab',
        onPressed: () {
          context.push(AppRoutes.addExpensePath);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
