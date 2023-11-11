import 'package:firebase_auth/firebase_auth.dart';
import 'package:tictactoe/services/firestore_service.dart';

abstract class AuthenticationInterface {
  Future<void> register(String email, String password,
      String passwordConfirmation, String userName);
  Future<void> login(String email, String password);
  Future<void> signout();
}

class AuthenticationService extends AuthenticationInterface {
  @override
  Future<void> login(String email, String password) async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.trim(), password: password.trim());
  }

  // @override
  // Future<void> register(
  //     String email, String password, String passwordConfirmation) async {
  //   if (passwordConfirmation == password) {
  //     await FirebaseAuth.instance
  //         .createUserWithEmailAndPassword(
  //             email: email.trim(), password: password.trim())
  //         .then((value) {
  //       FirestoreService().createUser(email);
  //     });
  //   }
  // }

  @override
  Future<void> register(String email, String password,
      String passwordConfirmation, String userName) async {
    if (passwordConfirmation == password) {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: email.trim(), password: password.trim())
          .then((value) {
        FirestoreService().createUser(email, userName);
      });
    }
  }

  @override
  Future<void> signout() async {
    await FirebaseAuth.instance.signOut();
  }
}
