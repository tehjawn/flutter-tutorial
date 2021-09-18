import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter_tutorial_app/saved_names_route.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer' as developer;

class RandomWords extends StatefulWidget {
  const RandomWords({Key? key}) : super(key: key);

  @override
  _RandomWordsState createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final _suggestions = <WordPair>[];
  final _saved = <String>{};
  final _biggerFont = const TextStyle(fontSize: 18);

  @override
  void initState() {
    super.initState();
    // Future<String> savedPairs =
    _prefs.then((SharedPreferences prefs) {
      String locallySavedWords = (prefs.getString('favorite_words') ?? '');
      if (locallySavedWords.length > 2) {
        locallySavedWords
            .substring(1, locallySavedWords.length - 1)
            .split(',')
            .forEach((word) => _saved.add(word.trim()));
      }
      developer.log(locallySavedWords);
      developer.log(_saved.toString());
    });
  }

  // Private helper function that builds our list of word pairs
  Widget _buildSuggestions() {
    return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemBuilder: (BuildContext _context, int i) {
          if (i.isOdd) {
            // Adds a one-pixel high divider widget before each row
            return const Divider();
          }
          final int index = i ~/ 2; // Divides i by 2 and returns integer result
          if (index >= _suggestions.length) {
            // Generate 10 more word pairs and add them to the suggestions list
            _suggestions.addAll(generateWordPairs().take(10));
          }
          return _buildRow(_suggestions[index].asPascalCase);
        });
  }

  void _saveFavoriteWordPair(alreadySaved, pair) async {
    setState(() {
      if (alreadySaved) {
        _saved.remove(pair);
      } else {
        _saved.add(pair);
      }
    });
    SharedPreferences prefs = await _prefs;
    prefs.setString('favorite_words', _saved.toString());
  }

  // Private helper function that builds each row in the word pair list
  Widget _buildRow(String pair) {
    final alreadySaved = _saved.contains(pair); // Check if pair is in saved map
    return ListTile(
      title: Text(pair, style: _biggerFont),
      trailing: Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: () => _saveFavoriteWordPair(alreadySaved, pair),
    );
  }

  Route _buildSavedNamesRoute() {
    developer.log(_saved.toString());
    return SavedNamesRoute(builder: (BuildContext context) {
      final tiles = _saved.map((String pair) {
        return ListTile(title: Text(pair, style: _biggerFont));
      });
      final divided = tiles.isNotEmpty
          ? ListTile.divideTiles(context: context, tiles: tiles).toList()
          : <Widget>[];
      return Scaffold(
        appBar: AppBar(
          title: const Text('Saved Suggestions'),
          backgroundColor: Colors.blueGrey.shade800,
        ),
        body: ListView(
          children: divided,
        ),
      );
    });
  }

  void _pushSaved() {
    Navigator.of(context).push(_buildSavedNamesRoute());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Startup Name Generator'),
        backgroundColor: Colors.blueGrey,
        actions: [
          IconButton(
            onPressed: _pushSaved,
            icon: const Icon(Icons.list),
          )
        ],
      ),
      body: _buildSuggestions(),
    );
  }
}
