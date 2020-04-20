import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'pages/home.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  String name, email, displayPicture;

  final googleBlue = const Color(0xFF4285F4);
  // Create a GoogleSignIn instance
  final GoogleSignIn googleSignIn = GoogleSignIn();
  // Create a FirebaseAuth instance
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<FirebaseUser> _handleSignIn() async {

    // triggered from signInButton

    final GoogleSignInAccount googleUser = await googleSignIn.signIn();
    // this calls the inbuilt google sign in popup box
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    // this cross-verifies the email account auth and shows what the app is gonna fetch and all

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // each auth instance has a an accessToken, and each googleAuth object has an idToken

    var user = await auth.signInWithCredential(credential);
    // This returns a FirebaseAuthUser instance. This has a user attribute which is what we need
    return user.user;
  }

  signInSilently() async{
    // use the inbuilt sign in silently feature. We call this at initState so that if someone is already logged in, he doesn't have to login again
    var user = await googleSignIn.signInSilently();
    // It returns a FirebaseUser object, jismei displayName, email, photoUrl humei vo respective values de deti hain
    name = user.displayName;
    email = user.email;
    displayPicture = user.photoUrl;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => HomeScreen(
          name: name,
          email: email,
          displayPicURL: displayPicture,
        )
      )
    );
  }

  Widget signInButton(){
   return new Container(
      child: new RaisedButton(
        onPressed: () async{
          FirebaseUser user = await _handleSignIn();
          // Yahaan pr we get a FirebaseUser user object, jiska displayName, email, photoUrl we require to display in the subsequent pages
          name = user.displayName;
          email = user.email;
          displayPicture = user.photoUrl;       
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => HomeScreen(
                name: name,
                email: email,
                displayPicURL: displayPicture,
              )
            )
          );
        },
        padding: EdgeInsets.only(top: 3.0,bottom: 3.0,left: 3.0),
        color: const Color(0xFF4285F4),
        child: new Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new Image.asset(
              'assets/images/google-logo.jpg',
              height: 52.0,
            ),
            new Container(
              padding: EdgeInsets.only(left: 10.0,right: 10.0),
                child: new Text("Sign in with Google",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)
            ),
          ],
        )
      ),
    );
  }

  @override
  void initState() {
    signInSilently();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 64,
              ),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Lucy',
                  style: TextStyle(
                    fontSize: 32.0,
                    color: Colors.white,
                    fontFamily: "Montserrat",
                  ),
                ),
              ),
              Image.asset(
                'assets/images/lucy-logo-sm.png',
                width: 300.0,
                height: 300.0,
                fit: BoxFit.cover,
              ),
              signInButton(),
              SizedBox(
                height: 64,
              )
            ],
          ),
        ),
      )
    );
  }
}