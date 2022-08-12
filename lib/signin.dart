// ignore: unused_import
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_signup/signup.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'home.dart';

class Signin extends StatefulWidget {
  static const routeName = 'signin';
  const Signin({Key key}) : super(key: key);

  @override
  _SigninState createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  var _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  _Signin() async {
    var valid = _formKey.currentState.validate();
    User user;
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: _emailController.text, password: _passwordController.text);
      user = userCredential.user;

      if (user != null) {
        Navigator.pushNamed(context, Home.routeName);
      }
    } catch (e) {}
    if (!valid) {
      return;
    } else {}
  }

  _signinWithGoogle() async {
    try {
      final googleSignIn = GoogleSignIn();
      final user = await googleSignIn.signIn();
      if (user != null) {
        print('User name ' + user.displayName);
        if (user != null) {
          Navigator.pushNamed(context, Home.routeName);
        }
      } else {
        print('Sign in failed');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Firebase Sign in',
        ),
      ),
      body: Container(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.2,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    15,
                  ),
                ),
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email',
                  ),
                  controller: _emailController,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Please enter email";
                    }
                    if (!value.contains('@')) {
                      return "Invalid email";
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                  ),
                  controller: _passwordController,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Please enter password";
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: _Signin,
                child: Text(
                  'Signin ',
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Text("Don't have an account ? "),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, Signup.routeName);
                    },
                    child: Text(
                      'Sign Up',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: _signinWithGoogle,
                child: Text(
                  'Sign in with Google',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
