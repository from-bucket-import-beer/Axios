import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'pageHandler.dart';
import 'splashPage.dart';
import 'loginPage.dart';

String name, email, imageUrl;

class AuthHandler extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.onAuthStateChanged,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return SplashPage();
          else if (snapshot.hasData && snapshot.data != null) {
            name = snapshot.data.displayName;
            email = snapshot.data.email;
            imageUrl = snapshot.data.photoUrl;
            return PageHandler(
              name: name,
              email: email,
              imageUrl: imageUrl
            );
          } else
            return LoginPage();
        });
  }
}