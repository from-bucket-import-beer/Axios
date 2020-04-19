import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';

class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FlareActor(
          "assets/flares/loading.flr",
          animation: "active",
        ),
      ),
    );
  }
}