import 'package:automatically_guesses_random_words/presentation/automatically_guesses/bloc/automatically_guesses_bloc.dart';
import 'package:automatically_guesses_random_words/presentation/automatically_guesses/widgets/guesses_word_widget.dart';
import 'package:automatically_guesses_random_words/presentation/widget/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AutomaticallyGuessesView extends StatelessWidget {
  const AutomaticallyGuessesView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AutomaticallyGuessesBloc(),
      child: const _Body(),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AutomaticallyGuessesBloc, AutomaticallyGuessesState>(
      builder: (context, state) {
        final guestButton = ElevatedButton(
          onPressed: state.status == AutomaticallyGuessesStatus.process
              ? null
              : () => context
                  .read<AutomaticallyGuessesBloc>()
                  .add(AutomaticallyGuessesStart()),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.cyan,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: const AppText(
            'Start New Automatically Guessing Words',
            color: Colors.white,
          ),
        );

        return Scaffold(
          body: SafeArea(
            child: state.guessSeed == null
                ? Center(
                    child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppText(
                        'The Application Supports',
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                        color: Colors.grey.shade800,
                      ),
                      const SizedBox(height: 8),
                      AppText(
                        '"automatically guessing random words" in the',
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                        color: Colors.grey.shade600,
                        fontStyle: FontStyle.italic,
                      ),
                      const SizedBox(height: 12),
                      const AppText(
                        'WORDLE GAME',
                        fontWeight: FontWeight.w600,
                        fontSize: 30,
                        color: Color.fromARGB(255, 0, 143, 161),
                      ),
                      const SizedBox(height: 20),
                      guestButton,
                    ],
                  ))
                : Column(
                    children: [
                      const SizedBox(height: 20),

                      /// Grid view
                      Expanded(
                          child: GuessesWordWidget(
                        guessSeed: state.guessSeed,
                        limitGuessTime: context
                            .read<AutomaticallyGuessesBloc>()
                            .limitGuessTimes,
                      )),

                      /// Status
                      const SizedBox(height: 8),
                      Builder(builder: (context) {
                        Widget itemBuilder(
                                String key, String value, Color valueColor) =>
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                AppText('• $key: ', fontSize: 15),
                                AppText(
                                  value.toUpperCase(),
                                  fontWeight: FontWeight.w500,
                                  color: valueColor,
                                ),
                              ],
                            );

                        final Widget child;

                        switch (state.status) {
                          case AutomaticallyGuessesStatus.success:
                            child = Wrap(
                              spacing: 16,
                              alignment: WrapAlignment.center,
                              children: [
                                itemBuilder('Guess status', state.status.name,
                                    Colors.cyan),
                                itemBuilder('Guess times',
                                    state.guessTimes.toString(), Colors.blue),
                                itemBuilder(
                                    'Correct word',
                                    state.guessSeed?.lines.values.lastOrNull
                                            ?.map((e) => e.guess)
                                            .join('') ??
                                        '',
                                    Colors.cyan),
                              ],
                            );
                            break;
                          case AutomaticallyGuessesStatus.process:
                            child = Wrap(
                              spacing: 16,
                              children: [
                                itemBuilder('Guess status', state.status.name,
                                    Colors.orange),
                                itemBuilder('Guess times',
                                    state.guessTimes.toString(), Colors.orange),
                              ],
                            );
                            break;
                          case AutomaticallyGuessesStatus.failed:
                            child = Wrap(
                              spacing: 16,
                              children: [
                                itemBuilder('Guess status', state.status.name,
                                    Colors.red),
                                itemBuilder(
                                    'Issue',
                                    state.guessSeed!.lines.length ==
                                            context
                                                .read<
                                                    AutomaticallyGuessesBloc>()
                                                .limitGuessTimes
                                        ? 'Times limit'
                                        : 'AI model Error',
                                    Colors.red),
                              ],
                            );
                            break;
                          default:
                            child = const SizedBox.shrink();
                        }

                        return child;
                      }),
                      const SizedBox(height: 8),

                      /// Bottom bar
                      Container(
                        padding:
                            const EdgeInsetsDirectional.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                            border: Border(
                                top: BorderSide(
                                    color: Colors.blueGrey.shade300))),
                        alignment: Alignment.center,
                        child: guestButton,
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }
}
