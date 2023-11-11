import 'package:flutter/material.dart';
import 'package:tictactoe/game_page.dart';
import 'package:tictactoe/snake_game.dart';
import 'package:tictactoe/services/auth_services.dart';
import 'package:tictactoe/services/firestore_service.dart';

class GamesHub extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: FirestoreService()
          .getUserUsername(), // Use the function to get the username
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show a loading indicator while fetching data
          return Scaffold(
            appBar: AppBar(
              title: Text('Games Hub'),
              backgroundColor: Colors.black,
              actions: [
                // Add a Logout button to the app bar
                IconButton(
                  icon: Icon(Icons.exit_to_app),
                  onPressed: () async {
                    await AuthenticationService().signout();
                  },
                ),
              ],
            ),
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          if (snapshot.hasError) {
            // Handle errors
            return Scaffold(
              appBar: AppBar(
                title: Text('Games Hub'),
                backgroundColor: Colors.black,
                actions: [
                  // Add a Logout button to the app bar
                  IconButton(
                    icon: Icon(Icons.exit_to_app),
                    onPressed: () async {
                      await AuthenticationService().signout();
                    },
                  ),
                ],
              ),
              body: Center(
                child: Text('Error: ${snapshot.error}'),
              ),
            );
          } else {
            // Display the app with the fetched username
            String username = snapshot.data ?? 'Username';
            return Scaffold(
              appBar: AppBar(
                title: _buildAppBarTitle(username),
                backgroundColor: Colors.black,
                actions: [
                  // Add a Logout button to the app bar
                  IconButton(
                    icon: Icon(Icons.exit_to_app),
                    onPressed: () async {
                      await AuthenticationService().signout();
                    },
                  ),
                ],
              ),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => GamePage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 10,
                        minimumSize: Size(200, 50),
                        primary: Colors.black,
                      ),
                      child: Text(
                        'Tic Tac Toe',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SnakeGame()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 10,
                        minimumSize: Size(200, 50),
                        primary: Colors.black,
                      ),
                      child: Text(
                        'Snake Game',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        }
      },
    );
  }

  // Custom widget to display the AppBar title with username
  Widget _buildAppBarTitle(String username) {
    return Row(
      children: [
        Text(
          'Games Hub',
          style: TextStyle(fontSize: 20),
        ),
        SizedBox(
            width: 8), // Add some spacing between "Games Hub" and the username
        Text(
          '- $username',
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}
