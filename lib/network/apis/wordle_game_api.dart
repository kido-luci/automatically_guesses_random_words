import 'package:http/http.dart' as http;

final class WordleGameApi {
  WordleGameApi._();

  static Future<http.Response> guessRandom(
      {required int seed, required String guess, required int size}) async {
    final response = http.get(Uri.https('wordle.votee.dev:8000', '/random', {
      'guess': guess,
      'seed': seed.toString(),
      'size': size.toString(),
    }));

    return response;
  }
}
