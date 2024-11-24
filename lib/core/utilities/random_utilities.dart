import 'dart:math';

final class RandomUtilities {
  RandomUtilities._();

  static int nextInt({int min = 0, required int max, int? except}) {
    assert(min < max);

    int result;

    final range = max - min;

    do {
      final tmp = Random().nextInt(range);
      result = tmp + min;
    } while (except != null && range > 2 && result == except);

    return result;
  }

  static String nextLetter() {
    final randomAscii = nextInt(max: 90, min: 65);

    return String.fromCharCode(randomAscii);
  }
}
