// import 'package:firebase_todo/data/auth_data.dart';
import 'package:flutter/material.dart';
import 'package:tictactoe/services/auth_services.dart';

class SignUpScreen extends StatefulWidget {
  final VoidCallback show;
  const SignUpScreen(this.show, {super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();
  final FocusNode _focusNode3 = FocusNode();
  final FocusNode _focusNode4 = FocusNode();

  final email = TextEditingController();
  final password = TextEditingController();
  final passwordConfirmation = TextEditingController();
  final userName = TextEditingController();

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

    super.initState();
    _focusNode3.addListener(() {
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
                inputField(userName, _focusNode4, 'Username', Icons.person),
                const SizedBox(height: 10),
                inputField(
                    email, _focusNode1, 'Email', Icons.email), // Email Field
                const SizedBox(height: 10),
                inputField(password, _focusNode2, 'Password', Icons.password),
                const SizedBox(height: 10),
                inputField(passwordConfirmation, _focusNode3,
                    'Confirm Password', Icons.password),
                const SizedBox(height: 8),
                loginBtn(),
                const SizedBox(height: 20),
                signUpBtn(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget loginBtn() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            "Already have an account?",
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 14,
            ),
          ),
          const SizedBox(width: 5),
          GestureDetector(
            onTap: widget.show,
            child: const Text(
              "Login",
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

  Widget signUpBtn() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: GestureDetector(
        onTap: () {
          AuthenticationService().register(email.text, password.text,
              passwordConfirmation.text, userName.text);
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
            'Sign Up',
            style: TextStyle(
                color: Colors.white, fontSize: 23, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  // ignore: no_leading_underscores_for_local_identifiers
  Widget inputField(TextEditingController _controller, FocusNode _focusNode,
      String typeName, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: TextField(
          obscureText: typeName == "Password" || typeName == "Confirm Password",
          controller: _controller,
          focusNode: _focusNode,
          style: const TextStyle(
            fontSize: 18,
            color: Colors.black,
          ),
          decoration: InputDecoration(
            prefixIcon: Icon(
              icon,
              color:
                  _focusNode.hasFocus ? Colors.green : const Color(0xffc5c5c5),
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

  // Image method
  Widget image() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        width: double.infinity,
        height: 300,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/7.png'),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
