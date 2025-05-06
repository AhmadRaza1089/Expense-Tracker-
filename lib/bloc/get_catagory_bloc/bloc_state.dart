part of 'bloc_bloc.dart';

// @immutable
sealed class BlocState {}

final class BlocInitial extends BlocState {}

final class CategoryFailure extends BlocState {}

final class CategoryLoading extends BlocState {}

final class CategorySuccess extends BlocState {}
