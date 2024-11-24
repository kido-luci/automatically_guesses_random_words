// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'guess_word.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GuessWord _$GuessWordFromJson(Map<String, dynamic> json) => GuessWord(
      slot: (json['slot'] as num).toInt(),
      guess: json['guess'] as String,
      result: $enumDecode(_$GuessResultEnumMap, json['result']),
    );

Map<String, dynamic> _$GuessWordToJson(GuessWord instance) => <String, dynamic>{
      'slot': instance.slot,
      'guess': instance.guess,
      'result': _$GuessResultEnumMap[instance.result]!,
    };

const _$GuessResultEnumMap = {
  GuessResult.absent: 'absent',
  GuessResult.present: 'present',
  GuessResult.correct: 'correct',
  GuessResult.wait: 'wait',
};
