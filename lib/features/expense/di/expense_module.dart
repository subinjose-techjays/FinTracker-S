import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../data/model/expense_model.dart';
import '../data/repository/expense_repository_impl.dart';
import '../domain/repository/expense_repository.dart';
import '../domain/usecase/add_expense_usecase.dart';
import '../domain/usecase/delete_expense_usecase.dart';
import '../domain/usecase/get_expenses_usecase.dart';
import '../presentation/viewmodel/expense_view_model.dart';
import '../presentation/viewmodel/add_expense_form_view_model.dart';

final expenseBoxProvider = Provider<Box<ExpenseModel>>((ref) {
  return Hive.box<ExpenseModel>('expenses');
});

final expenseRepositoryProvider = Provider<ExpenseRepository>((ref) {
  final box = ref.watch(expenseBoxProvider);
  return ExpenseRepositoryImpl(box);
});

final getExpensesUseCaseProvider = Provider<GetExpensesUseCase>((ref) {
  final repository = ref.watch(expenseRepositoryProvider);
  return GetExpensesUseCase(repository);
});

final addExpenseUseCaseProvider = Provider<AddExpenseUseCase>((ref) {
  final repository = ref.watch(expenseRepositoryProvider);
  return AddExpenseUseCase(repository);
});

final deleteExpenseUseCaseProvider = Provider<DeleteExpenseUseCase>((ref) {
  final repository = ref.watch(expenseRepositoryProvider);
  return DeleteExpenseUseCase(repository);
});

final expenseViewModelProvider =
    StateNotifierProvider<ExpenseViewModel, ExpenseState>((ref) {
      return ExpenseViewModel(
        getExpensesUseCase: ref.watch(getExpensesUseCaseProvider),
        addExpenseUseCase: ref.watch(addExpenseUseCaseProvider),
        deleteExpenseUseCase: ref.watch(deleteExpenseUseCaseProvider),
      );
    });

final addExpenseFormViewModelProvider =
    StateNotifierProvider.autoDispose<
      AddExpenseFormViewModel,
      AddExpenseFormState
    >((ref) {
      return AddExpenseFormViewModel();
    });
