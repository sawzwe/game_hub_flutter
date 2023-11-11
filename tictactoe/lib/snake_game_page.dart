import 'dart:async';
import 'dart:math';

import 'package:tictactoe/game_over.dart';
import 'package:flutter/material.dart';

class SnakeGamePage extends StatefulWidget {
  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<SnakeGamePage>
    with TickerProviderStateMixin {
  late int _playerScore;
  late bool _hasStarted;
  late Animation<double> _snakeAnimation;
  late AnimationController _snakeController;
  List<int> _snake = [404, 405, 406, 407];
  List<int> _obstacles = []; // Add this line
  final int _noOfSquares = 500;
  final Duration _duration = Duration(milliseconds: 250);
  final int _squareSize = 20;
  late String _currentSnakeDirection;
  late int _snakeFoodPosition;
  Random _random = new Random();
  late Timer _foodTimer;
  late Timer _obstacleTimer;

  @override
  void initState() {
    super.initState();
    _setUpGame();
  }

  @override
  void dispose() {
    _stopFoodTimer();
    _stopObstacleTimer();
    _snakeController.dispose();
    super.dispose();
  }

  void _startFoodTimer() {
    _foodTimer = Timer.periodic(Duration(seconds: 8), (Timer timer) {
      if (!_hasStarted) {
        _updateFoodPosition();
      }
    });
  }

  void _stopFoodTimer() {
    _foodTimer.cancel();
  }

  void _setUpGame() {
    _playerScore = 0;
    _currentSnakeDirection = 'RIGHT';
    _hasStarted = true;
    do {
      _snakeFoodPosition = _random.nextInt(_noOfSquares);
    } while (_snake.contains(_snakeFoodPosition));
    _snakeController = AnimationController(vsync: this, duration: _duration);
    _snakeAnimation =
        CurvedAnimation(curve: Curves.easeInOut, parent: _snakeController);
    _startObstacleTimer();
  }

  void _startObstacleTimer() {
    _obstacleTimer = Timer.periodic(Duration(seconds: 5), (Timer timer) {
      if (!_hasStarted) {
        _updateObstacles();
      }
    });
  }

  void _stopObstacleTimer() {
    _obstacleTimer.cancel();
  }

  void _updateObstacles() {
    setState(() {
      _obstacles.clear(); // Remove existing obstacles
      for (int i = 0; i < 2; i++) {
        int obstaclePosition;
        do {
          obstaclePosition = _random.nextInt(_noOfSquares);
        } while (_snake.contains(obstaclePosition) ||
            _obstacles.contains(obstaclePosition) ||
            obstaclePosition == _snakeFoodPosition);

        _obstacles.add(obstaclePosition);
      }
    });
  }

  void _gameStart() {
    _startFoodTimer();
    _startObstacleTimer();
    Timer.periodic(Duration(milliseconds: 250), (Timer timer) {
      _updateSnake();
      if (_hasStarted) {
        timer.cancel();
        _stopFoodTimer();
        _stopObstacleTimer();
      }
    });
  }

  bool _gameOver() {
    for (int i = 0; i < _snake.length - 1; i++)
      if (_snake.last == _snake[i]) return true;
    if (_obstacles.contains(_snake.last))
      return true; // Check for collision with obstacles
    return false;
  }

  void _updateFoodPosition() {
    setState(() {
      do {
        _snakeFoodPosition = _random.nextInt(_noOfSquares);
      } while (_snake.contains(_snakeFoodPosition) ||
          _obstacles.contains(_snakeFoodPosition));
    });
  }

  void _updateSnake() {
    if (!_hasStarted) {
      setState(() {
        _playerScore = (_snake.length - 4) * 100;
        switch (_currentSnakeDirection) {
          case 'DOWN':
            if (_snake.last > _noOfSquares)
              _snake.add(
                  _snake.last + _squareSize - (_noOfSquares + _squareSize));
            else
              _snake.add(_snake.last + _squareSize);
            break;
          case 'UP':
            if (_snake.last < _squareSize)
              _snake.add(
                  _snake.last - _squareSize + (_noOfSquares + _squareSize));
            else
              _snake.add(_snake.last - _squareSize);
            break;
          case 'RIGHT':
            if ((_snake.last + 1) % _squareSize == 0)
              _snake.add(_snake.last + 1 - _squareSize);
            else
              _snake.add(_snake.last + 1);
            break;
          case 'LEFT':
            if ((_snake.last) % _squareSize == 0)
              _snake.add(_snake.last - 1 + _squareSize);
            else
              _snake.add(_snake.last - 1);
        }

        if (_snake.last != _snakeFoodPosition) {
          _snake.removeAt(0);
        } else {
          // Snake eats the food
          _resetFoodTimer();
          do {
            _snakeFoodPosition = _random.nextInt(_noOfSquares);
          } while (_snake.contains(_snakeFoodPosition) ||
              _obstacles.contains(_snakeFoodPosition));
        }

        if (_gameOver()) {
          setState(() {
            _hasStarted = !_hasStarted;
          });
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => GameOver(score: _playerScore)));
        }
      });
    }
  }

  void _resetFoodTimer() {
    // Reset the food timer
    _stopFoodTimer();
    _startFoodTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SnakeGameFlutter',
            style: TextStyle(color: Colors.white, fontSize: 20.0)),
        centerTitle: false,
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        actions: <Widget>[
          Center(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child:
                Text('Score: $_playerScore', style: TextStyle(fontSize: 16.0)),
          ))
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
          backgroundColor: const Color.fromARGB(255, 0, 0, 0),
          elevation: 20,
          label: Text(
            _hasStarted ? 'Start' : 'Pause',
            style: TextStyle(),
          ),
          onPressed: () {
            setState(() {
              if (_hasStarted)
                _snakeController.forward();
              else
                _snakeController.reverse();
              _hasStarted = !_hasStarted;
              _gameStart();
            });
          },
          icon: AnimatedIcon(
              icon: AnimatedIcons.play_pause, progress: _snakeAnimation)),
      body: Center(
        child: GestureDetector(
          onVerticalDragUpdate: (drag) {
            if (drag.delta.dy > 0 && _currentSnakeDirection != 'UP')
              _currentSnakeDirection = 'DOWN';
            else if (drag.delta.dy < 0 && _currentSnakeDirection != 'DOWN')
              _currentSnakeDirection = 'UP';
          },
          onHorizontalDragUpdate: (drag) {
            if (drag.delta.dx > 0 && _currentSnakeDirection != 'LEFT')
              _currentSnakeDirection = 'RIGHT';
            else if (drag.delta.dx < 0 && _currentSnakeDirection != 'RIGHT')
              _currentSnakeDirection = 'LEFT';
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: GridView.builder(
              itemCount: _squareSize + _noOfSquares,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: _squareSize),
              itemBuilder: (BuildContext context, int index) {
                return Center(
                  child: Container(
                    color: Colors.white,
                    padding: _snake.contains(index)
                        ? EdgeInsets.all(1)
                        : _obstacles.contains(index)
                            ? EdgeInsets.all(1)
                            : EdgeInsets.all(0),
                    child: ClipRRect(
                      borderRadius: index == _snakeFoodPosition ||
                              index == _snake.last ||
                              _obstacles.contains(index)
                          ? BorderRadius.circular(7)
                          : _snake.contains(index)
                              ? BorderRadius.circular(2.5)
                              : BorderRadius.circular(1),
                      child: Container(
                          color: _snake.contains(index)
                              ? Colors.black
                              : index == _snakeFoodPosition
                                  ? Colors.green
                                  : _obstacles.contains(index)
                                      ? Colors.red // Obstacle color
                                      : Colors.blue),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
