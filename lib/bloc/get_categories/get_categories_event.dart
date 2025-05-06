part of 'get_categories_bloc.dart';

@immutable
sealed class GetCategoriesEvent {
  const GetCategoriesEvent();
}

class GetCategories extends GetCategoriesEvent{}
