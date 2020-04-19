import 'package:flutter/material.dart';
import 'screens/authHandler.dart';

void main()
{
  return runApp(Application());

}

class Application extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      color: Color(0xFFE74C3C),
      theme: ThemeData(
        accentColor: Color(0xFFE74C3C),
        primaryColor: Color(0xFFE74C3C),
      ),
      home: AuthHandler(),
    );
  }
  
}