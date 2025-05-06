part of 'bloc_bloc.dart';

@immutable
sealed class BlocEvent {
  const BlocEvent();
}

class CreateCategory extends BlocEvent {
  final Category category;
  const CreateCategory(this.category);
}
