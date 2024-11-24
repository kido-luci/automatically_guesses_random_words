import 'package:automatically_guesses_random_words/data/models/common/app_animated_grid_items.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'app_animated_grid_state.dart';
part 'app_animated_grid_event.dart';

final class AppAnimatedGridBloc<T>
    extends Bloc<AppAnimatedGridEvent<T>, AppAnimatedGridState<T>> {
  AppAnimatedGridBloc([AppAnimatedGridState<T>? initState])
      : super(initState ?? AppAnimatedGridState<T>()) {
    on<AppAnimatedGridInit<T>>(_onInit);
    on<AppAnimatedGridInsert<T>>(_onInsert);
    on<AppAnimatedGridInsertAll<T>>(_onInsertAll);
    on<AppAnimatedGridRemove<T>>(_onRemove);
    on<AppAnimatedGridRemoveAll<T>>(_onRemoveAll);
  }

  void _onInit(
      AppAnimatedGridInit<T> event, Emitter<AppAnimatedGridState<T>> emit) {
    emit(state.copyWith(items: event.items));
  }

  void _onInsert(
      AppAnimatedGridInsert<T> event, Emitter<AppAnimatedGridState<T>> emit) {
    emit(state.copyWith(
        items: state.items
          ?..insert(
              event.index ?? state.items!.length, event.item, event.duration)));
  }

  void _onInsertAll(AppAnimatedGridInsertAll<T> event,
      Emitter<AppAnimatedGridState<T>> emit) {
    emit(state.copyWith(
        items: state.items
          ?..insertAll(event.index ?? state.items!.length, event.items,
              event.duration)));
  }

  void _onRemove(
      AppAnimatedGridRemove<T> event, Emitter<AppAnimatedGridState<T>> emit) {
    emit(state.copyWith(
        items: state.items
          ?..removeAt(event.index ?? state.items!.length - 1, event.duration)));
  }

  void _onRemoveAll(AppAnimatedGridRemoveAll<T> event,
      Emitter<AppAnimatedGridState<T>> emit) {
    emit(state.copyWith(items: state.items?..removeAll(event.duration)));
  }
}
