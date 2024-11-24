part of 'app_animated_grid_bloc.dart';

sealed class AppAnimatedGridEvent<T> {}

final class AppAnimatedGridInit<T> extends AppAnimatedGridEvent<T> {
  final AppAnimatedGridItems<T> items;

  AppAnimatedGridInit({required this.items});
}

final class AppAnimatedGridInsert<T> extends AppAnimatedGridEvent<T> {
  final int? index;
  final T item;
  final Duration duration;

  AppAnimatedGridInsert(
      {this.index, required this.item, required this.duration});
}

final class AppAnimatedGridInsertAll<T> extends AppAnimatedGridEvent<T> {
  final int? index;
  final List<T> items;
  final Duration duration;

  AppAnimatedGridInsertAll(
      {this.index, required this.items, required this.duration});
}

final class AppAnimatedGridRemove<T> extends AppAnimatedGridEvent<T> {
  final int? index;
  final Duration duration;

  AppAnimatedGridRemove({this.index, required this.duration});
}

final class AppAnimatedGridRemoveAll<T> extends AppAnimatedGridEvent<T> {
  final Duration duration;

  AppAnimatedGridRemoveAll({required this.duration});
}
