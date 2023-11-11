import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tictactoe/auth/auth_page.dart';
import 'package:tictactoe/gamesHub.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          print('Snap');
          if (snapshot.hasData) {
            return GamesHub();
          } else {
            return AuthPage();
          }
        },
      ),
    );
  }
}
