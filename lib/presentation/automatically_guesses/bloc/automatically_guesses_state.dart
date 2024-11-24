part of 'automatically_guesses_bloc.dart';

enum AutomaticallyGuessesStatus {
  init,
  process,
  success,
  failed,
}

final class AutomaticallyGuessesState extends Equatable {
  final GuessSeed? guessSeed;
  final String? error;
  final int guessTimes;
  final AutomaticallyGuessesStatus status;

  const AutomaticallyGuessesState(
      {this.guessSeed,
      this.error,
      this.guessTimes = 0,
      this.status = AutomaticallyGuessesStatus.init});

  AutomaticallyGuessesState copyWith(
          {GuessSeed? guessSeed,
          String? error,
          int? guessTimes,
          AutomaticallyGuessesStatus? status}) =>
      AutomaticallyGuessesState(
          guessSeed: guessSeed ?? this.guessSeed,
          error: error ?? this.error,
          status: status ?? this.status,
          guessTimes: guessTimes ?? this.guessTimes);

  @override
  List<Object?> get props => [guessSeed, error, status, guessTimes];
}
