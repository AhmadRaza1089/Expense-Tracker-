part of 'delete_category_bloc_bloc.dart';
@immutable
abstract class DeleteCategoryBlocEvent {}

class DeleteCategoryEvent extends DeleteCategoryBlocEvent {
  final String categoryId;

  DeleteCategoryEvent({required this.categoryId});
}