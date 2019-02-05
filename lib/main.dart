import 'package:flutter/material.dart';
import 'package:random_words/random_words.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'World Game',
      home: new RandomSentences()
    );
  }
}

class RandomSentences extends StatefulWidget {
  @override
  createState() => new _RandomSentencesState();
}

class _RandomSentencesState extends State<RandomSentences> {

  final _senteces = <String>[];
  final _funnies = new Set<String>();
  final _biggerFont = const TextStyle(fontSize: 14.0);

  @override
  Widget build(BuildContext context) {
    
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Word Game'),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.list),
            onPressed: _pushFunnies,
          )
        ],
      ),
      body: _buildSentences(),
    );
  }

  void _pushFunnies() {
    Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (context) {
          final tiles = _funnies.map(
            (sentece) {
              return new ListTile(
                title: new Text(
                  sentece, style: _biggerFont,
                ),
              );
            }
          );
          final divided = ListTile.divideTiles(
            context: context,
            tiles: tiles,
          ).toList(); 

          return new Scaffold(
            appBar: new AppBar(
              title: new Text('Saved Funny Sentences'),
            ),
            body: new ListView(children: divided),
          );
        }
      )
    );
  }

  String _getSentence() {
    final noun = new WordNoun.random();
    final adjective = new WordAdjective.random();
    return 'The $noun shouted and drove off with his $adjective wife.';
  }

  Widget _buildRow(String sentence) {
    final alreadyFoundFunny = _funnies.contains(sentence);
    return new ListTile(
      title: new Text(
        sentence,
        style: _biggerFont
      ),
      trailing: new Icon(
        alreadyFoundFunny ? Icons.thumb_up : Icons.thumb_down,
        color: alreadyFoundFunny ? Colors.green : null,
      ),
      onTap: () {
        setState(() {
          if (alreadyFoundFunny) {
            _funnies.remove(sentence);
          } else {
            _funnies.add(sentence);
          }
        });
      },
    );
  }

  Widget _buildSentences() {
    return new ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, i) {
        if (i.isOdd) return new Divider();
        final index = i ~/ 2;
        if (index >= _senteces.length) {
          for (int x = 0; x < 10; x++) {
            _senteces.add(_getSentence());
          }
        }
        return _buildRow(_senteces[index]);
      }
    );
  }
}