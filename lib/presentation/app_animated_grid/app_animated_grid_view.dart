import 'package:automatically_guesses_random_words/data/models/common/app_animated_grid_items.dart';
import 'package:automatically_guesses_random_words/presentation/app_animated_grid/bloc/app_animated_grid_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppAnimatedGridView<T> extends StatelessWidget {
  final AppAnimatedGridBloc<T>? bloc;
  final AppAnimatedGridItemBuilder itemBuilder, removedItemBuilder;
  final bool autoScrollToeEnd;

  const AppAnimatedGridView({
    super.key,
    this.bloc,
    required this.removedItemBuilder,
    required this.itemBuilder,
    this.autoScrollToeEnd = false,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => bloc ?? AppAnimatedGridBloc<T>(),
      child: _Body<T>(itemBuilder, removedItemBuilder, autoScrollToeEnd),
    );
  }
}

class _Body<T> extends StatefulWidget {
  final AppAnimatedGridItemBuilder itemBuilder, removedItemBuilder;
  final bool autoScrollToeEnd;

  const _Body(this.itemBuilder, this.removedItemBuilder, this.autoScrollToeEnd);

  @override
  State<_Body> createState() => _BodyState<T>();
}

class _BodyState<T> extends State<_Body> {
  final _gridKey = GlobalKey<AnimatedGridState>();
  final _scrollController = ScrollController();

  var _onScroll = false;

  @override
  void initState() {
    context.read<AppAnimatedGridBloc<T>>().add(
          AppAnimatedGridInit<T>(
            items: AppAnimatedGridItems<T>(
              listKey: _gridKey,
              initialItems: List<T>.empty(growable: true),
              removedItemBuilder: (item, context, animation) =>
                  widget.removedItemBuilder(item, context, animation),
            ),
          ),
        );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppAnimatedGridBloc<T>, AppAnimatedGridState<T>>(
      listener: (context, state) {
        if (widget.autoScrollToeEnd &&
            !_onScroll &&
            _scrollController.position.pixels !=
                _scrollController.position.maxScrollExtent) {
          _onScroll = true;

          Future.delayed(const Duration(milliseconds: 400))
              .then((value) => _onScroll = false);

          _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 400),
              curve: Curves.fastOutSlowIn);
        }
      },
      builder: (context, state) {
        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: AnimatedGrid(
              key: _gridKey,
              controller: _scrollController,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5),
              initialItemCount: state.items?.length ?? 0,
              itemBuilder: (context, index, animation) =>
                  widget.itemBuilder(state.items![index], context, animation),
            ),
          ),
        );
      },
    );
  }
}
