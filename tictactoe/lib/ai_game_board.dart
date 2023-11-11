import 'dart:math';
import 'package:flutter/material.dart';
import 'package:tictactoe/services/firestore_service.dart';

class AIGameBoard extends StatefulWidget {
  const AIGameBoard({Key? key}) : super(key: key);

  @override
  _AIGameBoardState createState() => _AIGameBoardState();
}

enum Difficulty { Impossible, Easy }

class _AIGameBoardState extends State<AIGameBoard> {
  List<List<String>> matrix = List.generate(3, (_) => List.filled(3, ''));
  String currentPlayer = 'X';
  String player = '';
  int scoreX = 0;
  int scoreO = 0;
  Difficulty selectedDifficulty = Difficulty.Impossible; // Default to Impossible
  List<int>? winnerLine;

  @override
  void initState() {
    super.initState();
    // Fetch the current user's username when the widget is initialized
    FirestoreService().getUserUsername().then((username) {
      setState(() {
        player = username;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(bottom: 15.0),
          child: Text(
            'Score:$player X - $scoreX :AI O - $scoreO',
            style: TextStyle(fontSize: 16),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Difficulty:'),
            Radio(
              value: Difficulty.Impossible,
              groupValue: selectedDifficulty,
              onChanged: (value) {
                setState(() {
                  selectedDifficulty = value as Difficulty;
                });
              },
            ),
            Text('Impossible'),
            Radio(
              value: Difficulty.Easy,
              groupValue: selectedDifficulty,
              onChanged: (value) {
                setState(() {
                  selectedDifficulty = value as Difficulty;
                });
              },
            ),
            Text('Baby Level'),
          ],
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
                    border: Border.all(color: Colors.black),
                  ),
                  child: Center(
                    child: Text(
                      matrix[i][j],
                      style: TextStyle(
                        fontSize: 48,
                        color: winnerLine != null && winnerLine!.contains(index)
                            ? Colors.green
                            : Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        ElevatedButton(
          onPressed: () {
            _resetGame();
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
          ),
          child: Text('Reset Game', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  void _handleTap(int i, int j) {
    if (matrix[i][j] == '' && currentPlayer == 'X' && !_isBoardFull()) {
      setState(() {
        matrix[i][j] = currentPlayer;
        if (_checkWinner(i, j)) {
          _handleWinner(currentPlayer);
        } else if (_isBoardFull()) {
          _showResult('Draw');
        } else {
          _aiMove();
        }
      });
    }
  }

  bool _checkWinner(int i, int j) {
    var player = matrix[i][j];

    // Check row
    for (int col = 0; col < 3; col++) {
      if (matrix[i][col] != player) {
        break;
      }
      if (col == 2) {
        winnerLine = [i * 3, i * 3 + 1, i * 3 + 2];
        return true;
      }
    }

    // Check column
    for (int row = 0; row < 3; row++) {
      if (matrix[row][j] != player) {
        break;
      }
      if (row == 2) {
        winnerLine = [j, j + 3, j + 6];
        return true;
      }
    }

    // Check diagonal
    if (i == j) {
      for (int diag = 0; diag < 3; diag++) {
        if (matrix[diag][diag] != player) {
          break;
        }
        if (diag == 2) {
          winnerLine = [0, 4, 8];
          return true;
        }
      }
    }

    // Check anti-diagonal
    if (i + j == 2) {
      for (int diag = 0; diag < 3; diag++) {
        if (matrix[diag][2 - diag] != player) {
          break;
        }
        if (diag == 2) {
          winnerLine = [2, 4, 6];
          return true;
        }
      }
    }

    return false;
  }

void _handleWinner(String player) {
  if (player == 'X') {
    scoreX++;
  } else if (player == 'O') {
    scoreO++;
    if (selectedDifficulty == Difficulty.Impossible) {
      // Update user score based on the game outcome
      int userScore = 0;
      if (player == 'X') {
        userScore = 500;
      } else if (player == 'O') {
        userScore = -100;
      } else {
        userScore = 50;
      }

      FirestoreService().getUserScore().then((currentScore) {
        FirestoreService().updateUserScore(currentScore + userScore);
      });
    }
  }
}

  void _showResult(String winner) {
  if (winner == 'Draw') {
    _handleDraw();
  } else {
    _handleWinner(winner);
  }

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Game Over?'),
        content: Text(
          winner == 'Draw' ? 'It\'s a Draw!' : 'Player $winner wins!',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Try Again'),
          ),
        ],
      );
    },
  );
}

void _handleDraw() {
  // Update user score for a draw
  if (selectedDifficulty == Difficulty.Impossible) {
    FirestoreService().getUserScore().then((currentScore) {
      // Add 50 points for a draw
      FirestoreService().updateUserScore(currentScore + 50);
    });
  }
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

  int _evaluateBoard() {
    for (int i = 0; i < 3; i++) {
      if (matrix[i][0] == matrix[i][1] && matrix[i][1] == matrix[i][2]) {
        if (matrix[i][0] == 'O') return 1;
        if (matrix[i][0] == 'X') return -1;
      }

      if (matrix[0][i] == matrix[1][i] && matrix[1][i] == matrix[2][i]) {
        if (matrix[0][i] == 'O') return 1;
        if (matrix[0][i] == 'X') return -1;
      }
    }

    if (matrix[0][0] == matrix[1][1] && matrix[1][1] == matrix[2][2]) {
      if (matrix[0][0] == 'O') return 1;
      if (matrix[0][0] == 'X') return -1;
    }

    if (matrix[0][2] == matrix[1][1] && matrix[1][1] == matrix[2][0]) {
      if (matrix[0][2] == 'O') return 1;
      if (matrix[0][2] == 'X') return -1;
    }

    return 0;
  }

  int _alphaBetaPruning(int depth, int alpha, int beta, bool isMaximizing) {
    int score = _evaluateBoard();

    if (score == 1 || score == -1) {
      return score;
    }

    if (_isBoardFull()) {
      return 0;
    }

    if (isMaximizing) {
      int maxEval = -1000;
      for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
          if (matrix[i][j] == '') {
            matrix[i][j] = 'O';
            int eval = _alphaBetaPruning(depth + 1, alpha, beta, false);
            matrix[i][j] = '';
            maxEval = max(maxEval, eval);
            alpha = max(alpha, eval);
            if (beta <= alpha) {
              break;
            }
          }
        }
      }
      return maxEval;
    } else {
      int minEval = 1000;
      for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
          if (matrix[i][j] == '') {
            matrix[i][j] = 'X';
            int eval = _alphaBetaPruning(depth + 1, alpha, beta, true);
            matrix[i][j] = '';
            minEval = min(minEval, eval);
            beta = min(beta, eval);
            if (beta <= alpha) {
              break;
            }
          }
        }
      }
      return minEval;
    }
  }

  void _aiMove() {
    int bestScore = selectedDifficulty == Difficulty.Impossible ? -1000 : 1000;
    int bestMoveI = -1;
    int bestMoveJ = -1;

    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (matrix[i][j] == '') {
          matrix[i][j] = 'O';
          int moveScore = _alphaBetaPruning(0, -1000, 1000, false);
          matrix[i][j] = '';

          if (selectedDifficulty == Difficulty.Impossible) {
            if (moveScore > bestScore) {
              bestScore = moveScore;
              bestMoveI = i;
              bestMoveJ = j;
            }
          } else {
            if (moveScore < bestScore) {
              bestScore = moveScore;
              bestMoveI = i;
              bestMoveJ = j;
            }
          }
        }
      }
    }

    matrix[bestMoveI][bestMoveJ] = 'O';
    if (_checkWinner(bestMoveI, bestMoveJ)) {
      _handleWinner('O');
    } else if (_isBoardFull()) {
      _showResult('Draw');
    }
  }

  void _resetGame() {
    setState(() {
      matrix = List.generate(3, (_) => List.filled(3, ''));
      currentPlayer = 'X';
      winnerLine = null; // Reset the winner line indicator
    });
  }
}
