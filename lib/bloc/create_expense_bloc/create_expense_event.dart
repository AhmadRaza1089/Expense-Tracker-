part of 'create_expense_bloc.dart';

@immutable
sealed class CreateExpenseEvent {}
final class CreateExpense extends CreateExpenseEvent {
  final Expense expense;
  CreateExpense(this.expense);
}
