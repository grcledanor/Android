import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hangman Game',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const HangmanGame(),
    );
  }
}

class HangmanGame extends StatefulWidget {
  const HangmanGame({super.key});
  @override
  State<HangmanGame> createState() => _HangmanGameState();
}

class _HangmanGameState extends State<HangmanGame> {
  final List<Map<String, String>> _wordsList = [
    {'word': 'BONJOU', 'hint': 'Se yon mo ki itilize pou salye moun'},
    {'word': 'MESI', 'hint': 'Se yon mo ki itilize pou remèsye'},
    {'word': 'KOTE', 'hint': 'Se yon mo ki mande pozisyon yon bagay'},
    {'word': 'KAY', 'hint': 'Se yon bilding kote moun rete'},
    {'word': 'JOU', 'hint': 'Se yon peryòd 24 èdtan'},
    {'word': 'NUIT', 'hint': 'Se lè solèy kouche, fè nwa'},
    {'word': 'DOMI', 'hint': 'Se yon bagay moun fè pour repoze'},
    {'word': 'DLO', 'hint': 'Se yon likid transparan nou bwè'},
    {'word': 'SIWO', 'hint': 'Se yon bagay ki dous'},
  ];

  late String _currentWord;
  late String _hint;
  late List<String> _guessedLetters;
  late int _remainingGuesses;
  late List<String> _displayWord;
  bool _gameWon = false;
  bool _gameLost = false;
  bool _showGoodbyePage = false;

  final List<List<String>> _keyboardRows = [
    ['Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P'],
    ['A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L'],
    ['Z', 'X', 'C', 'V', 'B', 'N', 'M'],
  ];

  @override
  void initState() {
    super.initState();
    _startNewGame();
  }

  void _startNewGame() {
    final random = Random();
    final selectedWord = _wordsList[random.nextInt(_wordsList.length)];
    setState(() {
      _currentWord = selectedWord['word']!;
      _hint = selectedWord['hint']!;
      _guessedLetters = [];
      _remainingGuesses = 5;
      _displayWord = List.filled(_currentWord.length, '*');
      _gameWon = false;
      _gameLost = false;
      _showGoodbyePage = false;
    });
  }

  void _guessLetter(String letter) {
    if (_guessedLetters.contains(letter) || _gameWon || _gameLost) return;
    setState(() {
      _guessedLetters.add(letter);
      if (_currentWord.contains(letter)) {
        for (int i = 0; i < _currentWord.length; i++) {
          if (_currentWord[i] == letter) _displayWord[i] = letter;
        }
        if (!_displayWord.contains('*')) _gameWon = true;
      } else {
        _remainingGuesses--;
        if (_remainingGuesses <= 0) {
          _gameLost = true;
          for (int i = 0; i < _currentWord.length; i++) {
            _displayWord[i] = _currentWord[i];
          }
        }
      }
    });
  }

  Widget _keyboardButton(String letter, BuildContext context) {
    final isGuessed = _guessedLetters.contains(letter);
    final isCorrect = _currentWord.contains(letter);
    final screenWidth = MediaQuery.of(context).size.width;
    final buttonWidth = (screenWidth - 20) / 10;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
      child: ElevatedButton(
        onPressed: isGuessed || _gameWon || _gameLost ? null : () => _guessLetter(letter),
        style: ElevatedButton.styleFrom(
          backgroundColor: isGuessed ? (isCorrect ? Colors.green : Colors.red) : Colors.white,
          foregroundColor: isGuessed ? Colors.white : Colors.blue,
          minimumSize: Size(buttonWidth, 40),
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
            side: BorderSide(color: isGuessed ? (isCorrect ? Colors.green : Colors.red) : Colors.blue, width: 1.5),
          ),
          elevation: 2,
        ),
        child: Text(letter, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    );
  }

  void _showExitConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Kite jwèt la?'),
        content: const Text('Èske ou sèten ou vle kite jwèt la?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('NON')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() => _showGoodbyePage = true);
            },
            child: const Text('WI', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildGoodbyePage() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.thumb_up, size: 60, color: Colors.blue),
            const SizedBox(height: 20),
            const Text('Mèsi paske w te jwe ak nou.', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue), textAlign: TextAlign.center),
            const SizedBox(height: 10),
            const Text('N ap tann ou yon lòt fwa!', style: TextStyle(fontSize: 16, color: Colors.black87), textAlign: TextAlign.center),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _showGoodbyePage = false;
                  _startNewGame();
                });
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12)),
              child: const Text('Rejwe'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_showGoodbyePage) return _buildGoodbyePage();
    if (_gameWon || _gameLost) {
      return Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [_gameWon ? Colors.green.shade50 : Colors.blue.shade50, Colors.white],
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(_gameWon ? '🎉' : '😔', style: const TextStyle(fontSize: 60)),
                const SizedBox(height: 20),
                Text(_gameWon ? 'OU GENYEN!' : 'OU PEDI!', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: _gameWon ? Colors.green : Colors.red)),
                const SizedBox(height: 15),
                Text('Mo a te: $_currentWord', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue), textAlign: TextAlign.center),
                const SizedBox(height: 15),
                Text(_gameWon ? 'Felisitasyon! Ou jwenn mo a!' : 'Padon! Ou pa t jwenn mo a.', style: const TextStyle(fontSize: 16, color: Colors.black87), textAlign: TextAlign.center),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: _startNewGame,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.replay, size: 20), SizedBox(width: 8), Text('Rejwe', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))]),
                    ),
                    ElevatedButton(
                      onPressed: _showExitConfirmation,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.exit_to_app, size: 20), SizedBox(width: 8), Text('Kite', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))]),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hangman Game', style: TextStyle(fontSize: 16)),
        backgroundColor: Colors.blue,
        centerTitle: true,
        toolbarHeight: 48,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: Row(
              children: [
                ...List.generate(5, (index) => Icon(Icons.star, size: 20, color: index < _remainingGuesses ? Colors.amber : Colors.grey[300])),
                const SizedBox(width: 8),
                Text('$_remainingGuesses', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text('DEVINE MO A', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(children: [
                        const Text('ENDIS:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue, fontSize: 12)),
                        const SizedBox(height: 3),
                        Text(_hint, style: const TextStyle(fontSize: 11, fontStyle: FontStyle.italic, color: Colors.black87), textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis),
                      ]),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.blue, width: 1.5),
                    boxShadow: [BoxShadow(color: Colors.blue.withOpacity(0.05), blurRadius: 2, offset: const Offset(0, 1))],
                  ),
                  child: Center(child: Text(_displayWord.join(' '), style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 1.5, color: Colors.blue))),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      const Text('Lèt ou te eseye:', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black54)),
                      const SizedBox(height: 3),
                      SizedBox(
                        height: 30,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: _guessedLetters.map((letter) => Container(
                              margin: const EdgeInsets.only(right: 4),
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: _currentWord.contains(letter) ? Colors.green.shade100 : Colors.red.shade100,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: _currentWord.contains(letter) ? Colors.green : Colors.red, width: 1),
                              ),
                              child: Text(letter, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: _currentWord.contains(letter) ? Colors.green : Colors.red)),
                            )).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  color: Colors.blue.shade50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton.icon(
                        onPressed: _showExitConfirmation,
                        icon: const Icon(Icons.exit_to_app, size: 12),
                        label: const Text('Kite', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: _startNewGame,
                        icon: const Icon(Icons.refresh, size: 12),
                        label: const Text('Devine yon lòt mo', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            color: Colors.grey[100],
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            child: Column(
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.center, children: _keyboardRows[0].map((letter) => _keyboardButton(letter, context)).toList()),
                const SizedBox(height: 6),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: _keyboardRows[1].map((letter) => _keyboardButton(letter, context)).toList()),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                    ..._keyboardRows[2].map((letter) => _keyboardButton(letter, context)).toList(),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
