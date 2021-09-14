import "package:flutter/material.dart";
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import "../widgets/auth/auth_form.dart";

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  var _isLoading = false;
  void setLoading(bool isLoading) {
    _isLoading = isLoading;
  }

  void _submitAuthForm(String email, String password, String displayName,
      bool isLogin, BuildContext ctx) async {
    UserCredential userCredential;

    try {
      setState(() {
        setLoading(true);
      });
      if (isLogin) {
        userCredential = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        userCredential = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        CollectionReference users =
            FirebaseFirestore.instance.collection('users');
        await users
            .doc(userCredential.user?.uid)
            .set({'email': email, 'displayName': displayName});
      }
    } on FirebaseAuthException catch (err) {
      var message = 'An error occurred, please check your credentials!';

      if (err.message != null) {
        message = err.message.toString();
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
      print(err);
      setState(() {
        setLoading(false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: AuthForm(submitFn: _submitAuthForm, isLoading: _isLoading));
  }
}
