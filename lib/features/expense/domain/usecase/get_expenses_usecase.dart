import '../entity/expense_entity.dart';
import '../repository/expense_repository.dart';

class GetExpensesUseCase {
  final ExpenseRepository repository;

  GetExpensesUseCase(this.repository);

  Future<List<ExpenseEntity>> call() {
    return repository.getExpenses();
  }
}
