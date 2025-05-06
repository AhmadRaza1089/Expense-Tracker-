import 'package:meta/meta.dart';

@immutable
abstract class DeleteCategoryBlocState {}

class DeleteCategoryBlocInitial extends DeleteCategoryBlocState {}

class DeleteCategoryBlocLoading extends DeleteCategoryBlocState {}

class DeleteCategoryBlocLoaded extends DeleteCategoryBlocState {
  final String message;
  final bool success;
  final String deletedCategoryId;

  DeleteCategoryBlocLoaded({
    required this.message,
    required this.success,
    required this.deletedCategoryId,
  });
}

class DeleteCategoryBlocError extends DeleteCategoryBlocState {
  final String errorMessage;

  DeleteCategoryBlocError({
    required this.errorMessage,
  });
}