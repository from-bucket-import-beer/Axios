import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.height / 10,
              ),
              Container(
                height: MediaQuery.of(context).size.height / 1.5,
                width: MediaQuery.of(context).size.height / 1.5,
                child: FlareActor(
                  "assets/flares/loader.flr",
                  animation: "loading",
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(
                height: 32,
              ),
              Text(
                "Have to display all favorite shops and different favorite items!",
                style: GoogleFonts.raleway(
                  fontSize: 20
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 3,
              )
            ],
          )
        ),
      ),
    );
  }
}