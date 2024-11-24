import 'dart:convert';

import 'package:automatically_guesses_random_words/core/utilities/open_ai_utilities.dart';
import 'package:automatically_guesses_random_words/core/utilities/random_utilities.dart';
import 'package:automatically_guesses_random_words/data/models/guess_word/guess_word.dart';

final class _GuestLetter {
  final int index;
  String? letter;
  Set<String> excepts;

  _GuestLetter({required this.index, required this.excepts});
}

final class AutoGuessesWordsServices {
  AutoGuessesWordsServices._();

  static Future<String?> getGuessesWord(
      {required int wordLength,
      required Map<int, List<GuessWord>> lines}) async {
    String? result;

    String prompt;

    final letters = <int, _GuestLetter>{};
    final mustContains = <String>{},
        notContains = <String>{},
        wasGuesses = <String>{};

    // add int data for each letter in the word
    for (var i = 0; i < wordLength; i++) {
      letters[i] = _GuestLetter(index: i, excepts: <String>{});
    }

    // if no data provide random a new word
    if (lines.isEmpty) {
      // prompt example: Random an english word that has 5 letters and contain "Y" (answer by syntax {"word":<result>})
      prompt =
          'Random an english word that has $wordLength letters and contain "${RandomUtilities.nextLetter()}" (answer by syntax {"word":<result>})';

      //else set up to guess a word
    } else {
      // handle data for each line
      for (final line in lines.values) {
        var fullWord = '';

        for (final word in line) {
          fullWord += word.guess;

          switch (word.result) {
            // if the letter is correct set this letter to [letters] at index [word.slot]
            case GuessResult.correct:
              letters[word.slot]!.letter = word.guess;
              mustContains.add(word.guess);
              break;
            // if the letter is present that mean the value at index [word.slot] can be this letter
            // so add this letter to excepts list in [letters] at index [word.slot]
            case GuessResult.present:
              letters[word.slot]!.excepts.add(word.guess);
              mustContains.add(word.guess);
              break;
            // if the letter is absent that mean the guess word not contains this letter
            // so add this letter to all excepts list in [letters]
            case GuessResult.absent:
              notContains.add(word.guess);
              break;
            default:
          }
        }

        wasGuesses.add(fullWord);
      }

      final conditions = <String>[
        if (wasGuesses.isNotEmpty)
          'The word cannot be: ${(wasGuesses.map((e) => '"$e"')).join(', ')}',
        if (mustContains.isNotEmpty)
          'The word must contains letters: ${(mustContains.map((e) => '"$e"').toList()..sort((a, b) => a.compareTo(b))).join(', ')}',
        if (notContains.isNotEmpty)
          'The word not contains letters: ${(notContains.map((e) => '"$e"').toList()..sort((a, b) => a.compareTo(b))).join(', ')}'
      ];

      // set up prompt condition
      // prompt example:
      for (final letter in letters.values) {
        if (letter.letter != null) {
          conditions.add(
              'Letter at index ${letter.index} must be "${letter.letter}"');
        } else if (letter.excepts.isNotEmpty) {
          conditions.add(
              'Letter at index ${letter.index} cannot be: ${letter.excepts.map((e) => '"$e"').join(', ')}');
        }
      }

      /*prompt example:
        Give an English words that must be has 5 letters by following the rules(answer by syntax {"word":<result>}):
        The word cannot be: "equal", "brisk", "night", "mincy", "pinto", "inion"
        The word must contains letters: "i", "n", "o"
        The word not contains letters: "a", "b", "c", "e", "g", "h", "k", "l", "m", "p", "q", "r", "s", "t", "u", "y"
        Letter at index 0 cannot be: "n", "i"
        Letter at index 1 must be "i"
        Letter at index 2 cannot be: "i", "n"
        Letter at index 3 must be "o"
        Letter at index 4 must be "n"
      */
      prompt =
          'Give an English words that must be has $wordLength letters by following the rules(answer by syntax {"word":<result>}):\n${conditions.join('\n')}';
    }

    print(prompt);

    final message = await OpenAiUtilities.instance.sendMessage(prompt);

    print(message);

    if (message != null) {
      result = jsonDecode(message)['word'];

      if (result?.length != wordLength) throw Exception('Out of word length');

      if (lines.isNotEmpty) {
        final lastWord = lines.values.last.map((e) => e.guess).join('');
        if (result == lastWord) throw Exception('Duplication guess');
      }
    }

    return result;
  }
}
