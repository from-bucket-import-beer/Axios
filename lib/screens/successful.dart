import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';

class SuccessfulScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Center(
                child: Container(
                  height: MediaQuery.of(context).size.height / 1.5,
                  width: MediaQuery.of(context).size.height / 1.5,
                  child: Center(
                    child: FlareActor(
                      "assets/flares/checkbox.flr",
                      fit: BoxFit.contain,
                      animation: "checkmark_appear"
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 32,
              ),
              Text(
                "Order placed succesfully"
              )
            ],
          ),
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.pop(context);
        },
        child: Icon(Icons.done),
      ),
    );
  }
}