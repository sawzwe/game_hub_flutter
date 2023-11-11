import 'package:flutter/material.dart';
import 'package:tictactoe/snake_game_page.dart';

class SnakeGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Snake Game'),
        backgroundColor: Colors.black, // Set the background color to black
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Navigate back to the main page
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.blue,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/snake_game.jpg'),
            SizedBox(height: 50.0),
            Text(
              'Welcome to SnakeGameFlutter',
              style: TextStyle(
                color: Colors.white,
                fontSize: 40.0,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 50.0),
            ElevatedButton.icon(
              onPressed: () {
                // Navigate to the Snake game page or another appropriate page
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => SnakeGamePage()),
                );
              },
              icon: Icon(Icons.play_circle_filled,
                  color: Colors.white, size: 30.0),
              label: Text(
                "Start the Game...",
                style: TextStyle(color: Colors.white, fontSize: 20.0),
              ),
              style: ElevatedButton.styleFrom(
                primary: const Color.fromARGB(255, 0, 0, 0),
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
