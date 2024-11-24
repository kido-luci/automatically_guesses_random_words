import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'guess_word.g.dart';

@JsonSerializable()
final class GuessWord extends Equatable {
  final int slot;
  final String guess;
  final GuessResult result;

  const GuessWord(
      {required this.slot, required this.guess, required this.result});

  @override
  List<Object?> get props => [slot, guess, result];

  factory GuessWord.fromJson(Map<String, dynamic> json) =>
      _$GuessWordFromJson(json);

  Map<String, dynamic> toJson() => _$GuessWordToJson(this);
}

@JsonEnum()
enum GuessResult {
  absent(color: Color.fromARGB(255, 255, 107, 107)),
  present(color: Colors.blue),
  correct(color: Colors.cyan),
  wait(color: Colors.grey);

  final Color color;

  const GuessResult({required this.color});
}
