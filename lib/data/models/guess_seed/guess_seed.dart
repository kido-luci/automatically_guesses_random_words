import 'package:automatically_guesses_random_words/data/models/guess_word/guess_word.dart';
import 'package:equatable/equatable.dart';

final class GuessSeed extends Equatable {
  final int seed;
  final int wordLength;
  final Map<int, List<GuessWord>> lines;

  const GuessSeed({
    required this.seed,
    required this.wordLength,
    required this.lines,
  });

  GuessSeed copyWith({
    Map<int, List<GuessWord>>? lines,
  }) =>
      GuessSeed(seed: seed, wordLength: wordLength, lines: lines ?? this.lines);

  int get wordCount => lines.length * wordLength;

  @override
  List<Object?> get props => [seed, wordLength, lines];
}
