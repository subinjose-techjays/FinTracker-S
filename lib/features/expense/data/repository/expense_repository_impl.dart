import 'package:hive/hive.dart';
import '../../domain/entity/expense_entity.dart';
import '../../domain/repository/expense_repository.dart';
import '../model/expense_model.dart';

class ExpenseRepositoryImpl implements ExpenseRepository {
  final Box<ExpenseModel> _expenseBox;

  ExpenseRepositoryImpl(this._expenseBox);

  @override
  Future<List<ExpenseEntity>> getExpenses() async {
    return _expenseBox.values.map((e) => e.toEntity()).toList();
  }

  @override
  Future<void> addExpense(ExpenseEntity expense) async {
    final expenseModel = ExpenseModel.fromEntity(expense);
    await _expenseBox.put(expense.id, expenseModel);
  }

  @override
  Future<void> deleteExpense(String id) async {
    await _expenseBox.delete(id);
  }
}
