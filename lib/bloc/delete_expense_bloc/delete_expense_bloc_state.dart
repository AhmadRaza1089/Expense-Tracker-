part of 'delete_expense_bloc_bloc.dart';

@immutable
sealed class DeleteExpenseBlocState {}

final class DeleteExpenseBlocInitial extends DeleteExpenseBlocState {}

final class DeleteExpenseBlocLoading extends DeleteExpenseBlocState {}

final class DeleteExpenseBlocLoaded extends DeleteExpenseBlocState {
  final String message;
  final bool success;
  final String deletedCategoryId;
  DeleteExpenseBlocLoaded({
    required this.deletedCategoryId,
    required this.message,
    required this.success,
  });
}

final class DeleteExpenseBlocError extends DeleteExpenseBlocState {}
