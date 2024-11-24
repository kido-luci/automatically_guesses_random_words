import 'package:automatically_guesses_random_words/data/models/guess_seed/guess_seed.dart';
import 'package:automatically_guesses_random_words/data/models/guess_word/guess_word.dart';
import 'package:automatically_guesses_random_words/presentation/app_animated_grid/app_animated_grid_view.dart';
import 'package:automatically_guesses_random_words/presentation/app_animated_grid/widgets/grid_card_animated_item.dart';
import 'package:automatically_guesses_random_words/presentation/automatically_guesses/bloc/automatically_guesses_bloc.dart';
import 'package:automatically_guesses_random_words/presentation/widget/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GuessesWordWidget extends StatelessWidget {
  final GuessSeed? guessSeed;
  final int limitGuessTime;

  const GuessesWordWidget(
      {super.key, required this.guessSeed, required this.limitGuessTime});

  Widget itemChildBuilder(GuessWord guessesWord) {
    return AppText(
      guessesWord.guess.toUpperCase(),
      color: guessesWord.result.color,
      fontSize: 30,
      fontWeight: FontWeight.w500,
    );
  }

  @override
  Widget build(BuildContext context) {
    final guessSeed = this.guessSeed;

    return Column(
      children: [
        AppText(
          'Wordle Seed: ${guessSeed != null ? '#${guessSeed.seed}' : 'None'}',
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: Colors.cyan,
        ),
        const SizedBox(width: 20),
        AppText(
          '(Limit guess times: $limitGuessTime)',
          fontSize: 16,
          color: Colors.grey.shade700,
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: GuessResult.values
              .map((e) => e != GuessResult.wait
                  ? Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 10,
                            width: 10,
                            decoration: BoxDecoration(
                              color: e.color,
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                          const SizedBox(width: 6),
                          AppText(e.name.toUpperCase(),
                              fontSize: 15, fontWeight: FontWeight.w500),
                        ],
                      ),
                    )
                  : const SizedBox.shrink())
              .toList(),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: AppAnimatedGridView(
            bloc: context.read<AutomaticallyGuessesBloc>().appAnimatedGridBloc,
            autoScrollToeEnd: true,
            itemBuilder: (item, context, animation) =>
                GridCardAnimatedItemWidget(
              animation: animation,
              onTap: () {},
              child: itemChildBuilder(item),
            ),
            removedItemBuilder: (item, context, animation) =>
                GridCardAnimatedItemWidget(
              animation: animation,
              removing: true,
              child: itemChildBuilder(item),
            ),
          ),
        ),
      ],
    );
  }
}
