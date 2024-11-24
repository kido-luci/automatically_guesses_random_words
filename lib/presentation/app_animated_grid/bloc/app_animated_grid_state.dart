part of 'app_animated_grid_bloc.dart';

final class AppAnimatedGridState<T> {
  final AppAnimatedGridItems<T>? items;

  const AppAnimatedGridState({this.items});

  AppAnimatedGridState<T> copyWith({AppAnimatedGridItems<T>? items}) =>
      AppAnimatedGridState<T>(items: items ?? this.items);
}
