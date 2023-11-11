// import 'package:firebase_todo/data/auth_data.dart';
import 'package:flutter/material.dart';
import 'package:tictactoe/services/auth_services.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback show;
  const LoginScreen(this.show, {super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();

  final email = TextEditingController();
  final password = TextEditingController();

  bool isVisiblePassword = false;
  bool isVisibleConfirm = false;

  @override
  void initState() {
    super.initState();
    _focusNode1.addListener(() {
      setState(() {});
    });
    super.initState();
    _focusNode2.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                inputField(email, _focusNode1, 'Email', Icons.email,
                    null), // Email Field
                const SizedBox(height: 10),
                inputField(
                    password,
                    _focusNode2,
                    'Password',
                    Icons.password,
                    isVisiblePassword
                        ? Icons.visibility
                        : Icons.visibility_off),
                const SizedBox(height: 8),
                signUpBtn(),
                const SizedBox(height: 20),
                loginBtn(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget signUpBtn() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            "Don't have an account?",
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 14,
            ),
          ),
          const SizedBox(width: 5),
          GestureDetector(
            onTap: widget.show,
            child: const Text(
              "Sign Up",
              style: TextStyle(
                color: Colors.blue,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget loginBtn() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: GestureDetector(
        onTap: () {
          AuthenticationService().login(email.text, password.text);
        },
        child: Container(
          alignment: Alignment.center,
          width: double.infinity,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Text(
            'Login',
            style: TextStyle(
                color: Colors.white, fontSize: 23, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  // ignore: no_leading_underscores_for_local_identifiers
  Widget inputField(TextEditingController _controller, FocusNode _focusNode,
      String typeName, IconData prefixIcon, IconData? suffixIcon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: TextField(
          obscureText:
              (typeName == 'Password' || typeName == 'Confirm Password') &&
                  !isVisiblePassword,
          controller: _controller,
          focusNode: _focusNode,
          style: const TextStyle(
            fontSize: 18,
            color: Colors.black,
          ),
          decoration: InputDecoration(
            prefixIcon: Icon(
              prefixIcon,
              color:
                  _focusNode.hasFocus ? Colors.green : const Color(0xffc5c5c5),
            ),
            suffixIcon: GestureDetector(
              child: Icon(
                suffixIcon,
                color: _focusNode.hasFocus
                    ? Colors.green
                    : const Color(0xffc5c5c5),
              ),
              onTap: () {
                setState(() {
                  isVisiblePassword = !isVisiblePassword;
                });
              },
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 15,
            ),
            hintText: typeName,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Color(0xffc5c5c5),
                width: 2.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Colors.green,
                width: 2.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
