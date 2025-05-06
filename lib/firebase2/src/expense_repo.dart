

import 'package:track/firebase2/src/model/category.dart';
import 'package:track/firebase2/src/model/expense.dart';

abstract class ExpenseRepo {
  Future<void> createCategory(Category category);
  Future<void> createExpense(Expense expense);
  Future<void> deleteExpense(String expenseId);
  Future<void> deleteCategory(String categoryId);
  Future<List<Category>> getCategory();
  Future<List<Expense>> getExpense();

  // Future<void>createExpense(Expense expense) async {} // Change return type to match implementation
}