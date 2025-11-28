import '../entity/expense_entity.dart';
import '../repository/expense_repository.dart';

class AddExpenseUseCase {
  final ExpenseRepository repository;

  AddExpenseUseCase(this.repository);

  Future<void> call(ExpenseEntity expense) {
    return repository.addExpense(expense);
  }
}
