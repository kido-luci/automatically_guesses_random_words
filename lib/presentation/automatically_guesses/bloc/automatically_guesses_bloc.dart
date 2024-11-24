import 'package:automatically_guesses_random_words/core/utilities/random_utilities.dart';
import 'package:automatically_guesses_random_words/data/models/guess_seed/guess_seed.dart';
import 'package:automatically_guesses_random_words/data/models/guess_word/guess_word.dart';
import 'package:automatically_guesses_random_words/data/services/auto_guesses_words_services.dart';
import 'package:automatically_guesses_random_words/data/services/wordle_game_services.dart';
import 'package:automatically_guesses_random_words/presentation/app_animated_grid/bloc/app_animated_grid_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'automatically_guesses_event.dart';
part 'automatically_guesses_state.dart';

final class AutomaticallyGuessesBloc
    extends Bloc<AutomaticallyGuessesEvent, AutomaticallyGuessesState> {
  final _wordLength = 5, limitGuessTimes = 10, _seedLimit = 10000;
  final _animatedDuration = const Duration(milliseconds: 400);

  final appAnimatedGridBloc = AppAnimatedGridBloc<GuessWord>();

  AutomaticallyGuessesBloc([AutomaticallyGuessesState? initState])
      : super(initState ?? const AutomaticallyGuessesState()) {
    on<AutomaticallyGuessesStart>(_onStart);
  }

  void _onStart(AutomaticallyGuessesStart event,
      Emitter<AutomaticallyGuessesState> emit) async {
    /// clear old seed data in animated grid
    appAnimatedGridBloc
        .add(AppAnimatedGridRemoveAll(duration: _animatedDuration));

    /// create new seed with id is random in range 0 -> [_seedLimit]
    var guessSeed = GuessSeed(
        wordLength: _wordLength,
        seed: RandomUtilities.nextInt(
            max: _seedLimit, except: state.guessSeed?.seed),
        lines: const {});

    emit(state.copyWith(
        guessSeed: guessSeed,
        error: null,
        status: AutomaticallyGuessesStatus.process,
        guessTimes: 0));

    var guessTimes = 1;

    /// A Loop to guesses words util over [_maxGuessTimes] or find correct word
    while (guessTimes <= limitGuessTimes) {
      emit(state.copyWith(guessTimes: guessTimes));

      String? guessWord;

      /// Guess new word for current line
      try {
        guessWord = await AutoGuessesWordsServices.getGuessesWord(
            wordLength: _wordLength, lines: guessSeed.lines);
        if (guessWord == null) throw (Exception('Guess word is null'));
      } catch (e) {
        emit(state.copyWith(
            error: e.toString(), status: AutomaticallyGuessesStatus.failed));
        break;
      }

      /// Create new line from guess word
      final line = guessWord
          .split('')
          .asMap()
          .entries
          .map((e) =>
              GuessWord(slot: e.key, guess: e.value, result: GuessResult.wait))
          .toList();

      /// Add new line to ui
      appAnimatedGridBloc.add(AppAnimatedGridInsertAll(
          index: guessSeed.wordCount,
          items: line,
          duration: _animatedDuration));

      await Future.delayed(_animatedDuration);

      List<GuessWord> guessResult;

      /// Check guess word is correct or not in current random seed
      try {
        guessResult = await WordleGameServices.guessRandom(
            seed: guessSeed.seed, guess: guessWord, size: _wordLength);
      } catch (e) {
        emit(state.copyWith(
            error: e.toString(), status: AutomaticallyGuessesStatus.failed));
        break;
      }

      /// Set guess seed value by new instance with new lines data
      guessSeed = guessSeed
          .copyWith(lines: {...guessSeed.lines, guessTimes: guessResult});

      /// Update animated grid ui
      for (final _ in line) {
        appAnimatedGridBloc.add(AppAnimatedGridRemove(duration: Duration.zero));
      }

      var countCorrect = 0;

      for (final e in guessResult) {
        if (e.result == GuessResult.correct) countCorrect++;

        appAnimatedGridBloc
            .add(AppAnimatedGridInsert(item: e, duration: _animatedDuration));
        await Future.delayed(_animatedDuration);
      }

      final isSuccess = countCorrect == _wordLength;

      emit(state.copyWith(
          guessSeed: guessSeed,
          status: isSuccess
              ? AutomaticallyGuessesStatus.success
              : AutomaticallyGuessesStatus.process));

      if (isSuccess) break;

      guessTimes++;

      if (guessTimes > limitGuessTimes) {
        emit(state.copyWith(
            guessSeed: guessSeed,
            status: AutomaticallyGuessesStatus.failed,
            error: 'Over guess times limit'));
      }
    }
  }
}
