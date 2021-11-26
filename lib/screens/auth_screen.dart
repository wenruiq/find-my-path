import "package:flutter/material.dart";
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import "../widgets/auth/auth_form.dart";
import "../widgets/util//dismiss_keyboard.dart";

//* This is the login screen
class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  //* Create FirebaseAuth instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //* Submit form loading state
  var _isLoading = false;
  void setLoading(bool isLoading) {
    _isLoading = isLoading;
  }

  void _submitAuthForm(
      {required String email,
      required String displayName,
      required String password,
      required bool isVolunteer,
      required bool isLogin,
      required BuildContext ctx}) async {
    UserCredential userCredential;

    try {
      setState(() {
        setLoading(true);
      });
      if (isLogin) {
        userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      } else {
        userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
        CollectionReference users = FirebaseFirestore.instance.collection('users');
        await users.doc(userCredential.user?.uid).set({
          'email': email,
          'displayName': displayName,
          'isVolunteer': isVolunteer,
          'isAvailable': false,
          'badges': isVolunteer
              ? {
                  'friendly': 0,
                  'listener': 0,
                  'expert': 0,
                  'personality': 0,
                }
              : {},
        });
      }
    } on FirebaseAuthException catch (err) {
      String message = 'An network error occurred, please try again later.';
      if (err.code == 'wrong-password' || err.code == 'user-not-found') {
        message = 'Incorrect email or password, please try again.';
      }
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(ctx).errorColor,
        ),
      );
      setState(() {
        setLoading(false);
      });
    } catch (err) {
      setState(() {
        setLoading(false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: "You're on the login screen",
      child: DismissKeyboard(
        child: Scaffold(
            backgroundColor: Theme.of(context).primaryColor,
            body: SafeArea(child: AuthForm(submitFn: _submitAuthForm, isLoading: _isLoading))),
      ),
    );
  }
}
