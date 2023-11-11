// import 'package:flutter/material.dart';
// import 'package:tictactoe/game_board.dart';
// import 'package:tictactoe/ai_game_board.dart';

// class GamePage extends StatefulWidget {
//   const GamePage({Key? key}) : super(key: key);

//   @override
//   _GamePageState createState() => _GamePageState();
// }

// class _GamePageState extends State<GamePage> {
//   bool aiGame = false;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Tic Tac Toe'),
//         backgroundColor: Colors.black,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//         actions: [
//           IconButton(
//             icon: Icon(aiGame ? Icons.people_alt : Icons.computer),
//             onPressed: () {
//               setState(() {
//                 aiGame = !aiGame;
//               });
//             },
//           ),
//         ],
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             SizedBox(height: 20),
//             if (aiGame) AIGameBoard() else GameBoard(),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:tictactoe/game_board.dart';
import 'package:tictactoe/ai_game_board.dart';
import 'package:tictactoe/services/firestore_service.dart';

class GamePage extends StatefulWidget {
  const GamePage({Key? key}) : super(key: key);

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  bool aiGame = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tic Tac Toe'),
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(aiGame ? Icons.people_alt : Icons.computer),
            onPressed: () {
              setState(() {
                aiGame = !aiGame;
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.leaderboard),
            onPressed: () {
              _showHighScores(context);
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            if (aiGame) AIGameBoard() else GameBoard(),
          ],
        ),
      ),
    );
  }

  void _showHighScores(BuildContext context) {
  FirestoreService().getHighScores().then((highScores) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('High Scores'),
          content: Column(
            children: _buildHighScoreItems(highScores),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  });
}

List<Widget> _buildHighScoreItems(List<HighScore> highScores) {
  if (highScores.isEmpty) {
    return [Text('No high scores available.')];
  }

  return highScores.map((score) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(score.playerName),
          Text(score.score.toString()),
        ],
      ),
    );
  }).toList();
}
}
