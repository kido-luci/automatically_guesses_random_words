import 'dart:convert';

import 'package:automatically_guesses_random_words/network/apis/wordle_game_api.dart';
import 'package:automatically_guesses_random_words/data/models/guess_word/guess_word.dart';

final class WordleGameServices {
  WordleGameServices._();

  static Future<List<GuessWord>> guessRandom(
      {required int seed, required String guess, required int size}) async {
    final response =
        await WordleGameApi.guessRandom(seed: seed, guess: guess, size: size);

    if (response.statusCode.toString().startsWith('2')) {
      final result = <GuessWord>[];

      final data = jsonDecode(response.body) as List;

      for (final e in data) {
        result.add(GuessWord.fromJson(e));
      }

      return result;
    } else {
      throw Exception(response.body);
    }
  }
}
