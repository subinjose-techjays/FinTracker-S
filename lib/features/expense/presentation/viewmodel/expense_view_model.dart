import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entity/expense_entity.dart';
import '../../domain/usecase/add_expense_usecase.dart';
import '../../domain/usecase/delete_expense_usecase.dart';
import '../../domain/usecase/get_expenses_usecase.dart';

// State class for ExpenseViewModel
class ExpenseState {
  final List<ExpenseEntity> expenses;
  final bool isLoading;
  final String? error;

  ExpenseState({this.expenses = const [], this.isLoading = false, this.error});

  ExpenseState copyWith({
    List<ExpenseEntity>? expenses,
    bool? isLoading,
    String? error,
  }) {
    return ExpenseState(
      expenses: expenses ?? this.expenses,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class ExpenseViewModel extends StateNotifier<ExpenseState> {
  final GetExpensesUseCase _getExpensesUseCase;
  final AddExpenseUseCase _addExpenseUseCase;
  final DeleteExpenseUseCase _deleteExpenseUseCase;

  ExpenseViewModel({
    required GetExpensesUseCase getExpensesUseCase,
    required AddExpenseUseCase addExpenseUseCase,
    required DeleteExpenseUseCase deleteExpenseUseCase,
  }) : _getExpensesUseCase = getExpensesUseCase,
       _addExpenseUseCase = addExpenseUseCase,
       _deleteExpenseUseCase = deleteExpenseUseCase,
       super(ExpenseState()) {
    loadExpenses();
  }

  Future<void> loadExpenses() async {
    state = state.copyWith(isLoading: true);
    try {
      final expenses = await _getExpensesUseCase();
      // Sort by date descending
      expenses.sort((a, b) => b.date.compareTo(a.date));
      state = state.copyWith(expenses: expenses, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> addExpense({
    required String title,
    required double amount,
    required DateTime date,
    required String category,
  }) async {
    state = state.copyWith(isLoading: true);
    try {
      final expense = ExpenseEntity(
        id: const Uuid().v4(),
        title: title,
        amount: amount,
        date: date,
        category: category,
      );
      await _addExpenseUseCase(expense);
      await loadExpenses();
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> deleteExpense(String id) async {
    state = state.copyWith(isLoading: true);
    try {
      await _deleteExpenseUseCase(id);
      await loadExpenses();
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}
