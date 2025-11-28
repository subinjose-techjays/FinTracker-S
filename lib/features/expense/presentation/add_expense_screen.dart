import 'package:flutter/material.dart';
import 'package:fin_tracker/core/theme/app_colors.dart';

class AddExpenseScreen extends StatelessWidget {
  const AddExpenseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Add New Expense',
        style: TextStyle(
          color: AppColors.deepGreen,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
