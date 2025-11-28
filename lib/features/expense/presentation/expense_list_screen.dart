import 'package:flutter/material.dart';
import 'package:fin_tracker/core/theme/app_colors.dart';

class ExpenseListScreen extends StatelessWidget {
  const ExpenseListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Expense List',
        style: TextStyle(
          color: AppColors.deepGreen,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
