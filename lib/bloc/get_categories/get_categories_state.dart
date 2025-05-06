part of 'get_categories_bloc.dart';

@immutable
sealed class GetCategoriesState {
  const  GetCategoriesState();
}

class GetCategoriesInitial extends GetCategoriesState {}

class GetCategoriesFailure extends GetCategoriesState {}

class GetCategoriesLoading extends GetCategoriesState {}

class GetCategoriesSuccess extends GetCategoriesState {
  final List<Category> categories;
  const GetCategoriesSuccess(this.categories);
}
