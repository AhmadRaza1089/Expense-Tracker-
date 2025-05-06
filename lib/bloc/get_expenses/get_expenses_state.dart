part of 'get_expenses_bloc.dart';

@immutable
sealed class GetExpensesState {}

final class GetExpensesInitial extends GetExpensesState {}

final class GetExpensesLoading extends GetExpensesState {}

final class GetExpensesLoaded extends GetExpensesState {
  final List<Expense> expense;
  GetExpensesLoaded(this.expense);
}

final class GetExpensesError extends GetExpensesState {}
