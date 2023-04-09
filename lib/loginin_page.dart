import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _loading = false;

  void _signInWithGoogle() async {
    setState(() {
      _loading = true;
    });

    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ThingSpeakPage()),
        );
      }
    } catch (e) {
      setState(() {
        _loading = false;
      });
      print('Error signing in with Google: $e');
    }
  }

  void _signInWithEmailAndPassword() async {
    setState(() {
      _loading = true;
    });

    try {
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      final User? user = userCredential.user;

      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ThingSpeakPage()),
        );
      }
    } catch (e) {
      setState(() {
        _loading = false;
      });
      print('Error signing in with email and password: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: SignInButton(
                Buttons.Google,
                onPressed: _signInWithGoogle,
                text: 'Sign in with Google',
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'Email',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Password',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: _signInWithEmailAndPassword,
                child: _loading ? CircularProgressIndicator() : Text('Sign in'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
