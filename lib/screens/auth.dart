import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

class AuthProvider {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<bool> signInWithGoogle() async {
    GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();

    if (googleSignInAccount == null) return false;

    GoogleSignInAuthentication googleSignInAuthentication =
    await googleSignInAccount.authentication;

    AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    AuthResult authResult = await _auth.signInWithCredential(credential);

    if (authResult.user == null){
      return false;
    }

    var ref = Firestore.instance.collection("users");
    Map<String, dynamic> userDetails = {
      "name": authResult.user.displayName,
      "email": authResult.user.email,
      "photoUrl": authResult.user.photoUrl
    };

    var coords = await Geolocator().getLastKnownPosition(desiredAccuracy: LocationAccuracy.high);
    var address = await Geolocator().placemarkFromCoordinates(coords.latitude, coords.longitude);
    Map<String, dynamic> coordsMap = {
      "lat": coords.latitude.toString(),
      "lon": coords.longitude.toString()
    };
    userDetails["coords"] = coordsMap;
    userDetails["pincode"] = address[0].postalCode;
    await ref.document(authResult.user.email).setData(userDetails);

    return true;
  }

  Future<void> signOutGoogle() async {
    await _auth.signOut();
    await googleSignIn.signOut();
    print("signOutWithGoogle succeeded");
  }
}