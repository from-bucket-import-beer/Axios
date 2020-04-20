import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'auth.dart';

class AccountScreen extends StatefulWidget {

  final String name, email, imageURL;
  AccountScreen({this.name, this.email, this.imageURL});

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.height / 3.5,
              ),
              CircleAvatar(
                radius: 42,
                backgroundImage: NetworkImage(
                  widget.imageURL
                ),
              ),
              SizedBox(
                height: 32,
              ),
              Text(
                widget.name,
                style: GoogleFonts.raleway(
                  fontSize: 42
                )
              ),
              SizedBox(
                height: 32,
              ),
              Text(
                widget.email,
                style: GoogleFonts.varelaRound(
                  fontSize: 20
                )
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 3.5,
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => AuthProvider().signOutGoogle(),
        label: Text(
          "Logout"
        ),
        icon: Icon(Icons.power_settings_new),
      ),
    );
  }
}