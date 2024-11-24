import 'package:automatically_guesses_random_words/core/utilities/open_ai_utilities.dart';
import 'package:automatically_guesses_random_words/presentation/automatically_guesses/automatically_guesses_view.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  OpenAiUtilities.instance.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Automatically Guesses Random Words',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const AutomaticallyGuessesView(),
    );
  }
}
