import 'package:flutter/material.dart';

class GameBoard extends StatefulWidget {
  const GameBoard({Key? key}) : super(key: key);

  @override
  _GameBoardState createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  List<List<String>> matrix = List.generate(3, (_) => List.filled(3, ''));
  String currentPlayer = 'X';
  int scoreX = 0;
  int scoreO = 0;

  void _handleTap(int i, int j) {
    if (matrix[i][j] == '') {
      setState(() {
        matrix[i][j] = currentPlayer;
        currentPlayer = currentPlayer == 'X' ? 'O' : 'X';
      });
      _checkWinner(i, j);
    }
  }

  void _checkWinner(int i, int j) {
    String player = matrix[i][j];
    bool win = true;

    // Check row
    for (int k = 0; k < 3; k++) {
      if (matrix[i][k] != player) {
        win = false;
        break;
      }
    }

    if (!win) {
      win = true;
      // Check column
      for (int k = 0; k < 3; k++) {
        if (matrix[k][j] != player) {
          win = false;
          break;
        }
      }
    }

    if (!win && i == j) {
      win = true;
      // Check diagonal
      for (int k = 0; k < 3; k++) {
        if (matrix[k][k] != player) {
          win = false;
          break;
        }
      }
    }

    if (!win && i + j == 2) {
      win = true;
      // Check anti-diagonal
      for (int k = 0; k < 3; k++) {
        if (matrix[k][2 - k] != player) {
          win = false;
          break;
        }
      }
    }

    if (win) {
      _updateScores(player);
      _showResult('$player');
    } else if (_isBoardFull()) {
      // Check for a draw
      _showResult('Draw');
    }
  }

  void _updateScores(String player) {
    setState(() {
      if (player == 'X') {
        scoreX++;
      } else {
        scoreO++;
      }
    });
  }

  bool _isBoardFull() {
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (matrix[i][j] == '') {
          return false;
        }
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(
              bottom: 15.0), // Add some bottom margin to the container
          child: Text(
            'Score: Player X - $scoreX : Player O - $scoreO',
            style: TextStyle(fontSize: 16),
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          itemCount: 9,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
          ),
          itemBuilder: (context, index) {
            int i = index ~/ 3;
            int j = index % 3;
            return GestureDetector(
              onTap: () => _handleTap(i, j),
              child: GridTile(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Color.fromARGB(255, 0, 0, 0)),
                  ),
                  child: Center(
                    child: Text(
                      matrix[i][j],
                      style: const TextStyle(fontSize: 48),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  void _showResult(String winner) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Game Over'),
          content:
              Text(winner == 'Draw' ? 'It\'s a Draw!' : 'Player $winner wins!'),
          actions: [
            TextButton(
              onPressed: () {
                _resetGame(); // Reset the game when "Play Again" is pressed
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Play Again'),
            ),
          ],
        );
      },
    );
  }

  void _resetGame() {
    setState(() {
      matrix = List.generate(3, (_) => List.filled(3, ''));
      currentPlayer = 'X';
    });
  }
}
