import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

typedef AppAnimatedGridItemBuilder<T> = Widget Function(
    T item, BuildContext context, Animation<double> animation);

class AppAnimatedGridItems<T> extends Equatable {
  AppAnimatedGridItems({
    required this.listKey,
    required this.removedItemBuilder,
    Iterable<T>? initialItems,
  }) : _items = List<T>.from(initialItems ?? <T>[]);

  final GlobalKey<AnimatedGridState> listKey;
  final AppAnimatedGridItemBuilder<T> removedItemBuilder;
  final List<T> _items;

  AnimatedGridState? get _animatedGrid => listKey.currentState;

  void insert(int index, T item, Duration duration) {
    _items.insert(index, item);
    _animatedGrid?.insertItem(
      index,
      duration: duration,
    );
  }

  void insertAll(int index, List<T> items, Duration duration) {
    _items.insertAll(index, items);
    _animatedGrid?.insertAllItems(
      index,
      items.length,
      duration: duration,
    );
  }

  T removeAt(int index, Duration duration) {
    final T removedItem = _items.removeAt(index);
    if (removedItem != null) {
      _animatedGrid!.removeItem(
        index,
        (BuildContext context, Animation<double> animation) =>
            removedItemBuilder(removedItem, context, animation),
        duration: duration,
      );
    }
    return removedItem;
  }

  removeAll(Duration duration) {
    _items.clear();
    _animatedGrid!.removeAllItems(
        (context, animation) => ScaleTransition(
            scale: CurvedAnimation(parent: animation, curve: Curves.easeInOut)),
        duration: duration);
  }

  int get length => _items.length;

  T operator [](int index) => _items[index];

  @override
  List<Object?> get props => [_items];
}
