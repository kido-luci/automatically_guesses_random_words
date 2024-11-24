import 'dart:async';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:openai_dart/openai_dart.dart';

final class OpenAiUtilities {
  static final instance = OpenAiUtilities._();

  final _initializedCompleter = Completer();
  var _wasInit = false;

  late final OpenAIClient _client;

  OpenAiUtilities._();

  Future get initialized => _initializedCompleter.future;

  void init() async {
    if (_wasInit) return;
    _wasInit = true;

    await dotenv.load(fileName: ".env");

    final key = dotenv.env['OPENAI_API_KEY'];

    _client = OpenAIClient(apiKey: key!);

    _initializedCompleter.complete();
  }

  Future<String?> sendMessage(String prompt) async {
    await initialized;

    final res = await _client.createChatCompletion(
      request: CreateChatCompletionRequest(
        model: const ChatCompletionModel.modelId('gpt-4o'),
        messages: [
          ChatCompletionMessage.user(
            content: ChatCompletionUserMessageContent.string(prompt),
          ),
        ],
        temperature: 0,
      ),
    );

    return res.choices.first.message.content
        ?.replaceAll('```json', '')
        .replaceAll('```', '');
  }
}
