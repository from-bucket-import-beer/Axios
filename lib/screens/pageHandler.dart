import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'accountPage.dart';
import 'listNearbyShops.dart';
import 'orders.dart';
import 'home.dart';

class PageHandler extends StatefulWidget {

  final String name, email, imageUrl;
  PageHandler({this.name, this.email, this.imageUrl});

  @override
  _PageHandlerState createState() => _PageHandlerState();
}

class _PageHandlerState extends State<PageHandler> {

  String pageTitle = "Axios";
  String pinCode = "";
  Widget currentScreen = HomeScreen();

  getPinCode() async{
    var ref = await Firestore.instance.collection("users").where("email", isEqualTo: widget.email).getDocuments();
    setState(() {
      pinCode = ref.documents[0].data["pincode"];
    });
  }

  @override
  void initState() {
    getPinCode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          pageTitle,
          style: GoogleFonts.raleway(
            fontSize: 20
          )
        ),
      ),
      body: currentScreen,
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(
                widget.name,
                style: GoogleFonts.roboto(fontWeight: FontWeight.w600),
              ),
              accountEmail: Text(
                widget.email,
                style: GoogleFonts.roboto(fontWeight: FontWeight.w600),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(
                  widget.imageUrl
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text(
                "Home",
                style: GoogleFonts.roboto(fontWeight: FontWeight.w600),
              ),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  pageTitle = "Axios";
                  currentScreen = HomeScreen();
                });
              },
            ),
            ListTile(
              leading: Icon(Icons.store_mall_directory),
              title: Text(
                "Shops",
                style: GoogleFonts.roboto(fontWeight: FontWeight.w600),
              ),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  pageTitle = "Shops near me";
                  currentScreen = ShopsNearByScreen(
                    pinCode: pinCode,
                    email: widget.email,
                  );
                });
              },
            ),
            ListTile(
              leading: Icon(Icons.receipt),
              title: Text(
                "Orders",
                style: GoogleFonts.roboto(fontWeight: FontWeight.w600),
              ),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  pageTitle = "Order History";
                  currentScreen = OrderHistory(
                    email: widget.email,
                  );
                });
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text(
                "Profile",
                style: GoogleFonts.roboto(fontWeight: FontWeight.w600),
              ),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  pageTitle = "Profile";
                  currentScreen = AccountScreen(
                    name: widget.name,
                    email: widget.email,
                    imageURL: widget.imageUrl,
                  );
                });
              },
            )
          ],
        ),
      ),
    );
  }
}