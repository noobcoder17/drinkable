import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthProvider extends ChangeNotifier {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn();
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  GoogleSignInAccount get googleAcount {
    return _googleSignIn.currentUser;
  }

  User get user {
    return _firebaseAuth.currentUser;
  }

  Future<bool> selectGoogleAcount() async {
    try {
      await _googleSignIn.signOut();
      GoogleSignInAccount googleAccount = await _googleSignIn.signIn();
      QuerySnapshot querySnapshot = await _firestore.collection('users').where('google_id',isEqualTo: googleAccount.id).get();
      List<QueryDocumentSnapshot> docs = querySnapshot.docs;
      if(docs.length==0){
        return true;
      }
      return false;
    }catch(e){
      print(e);
      return true;
    }
  }

  Future<void> signIn() async {
     try{
      if(_googleSignIn.currentUser!=null){
        GoogleSignInAuthentication _googleSignInAuthentication = await _googleSignIn.currentUser.authentication;
        OAuthCredential _oAuthCredential = GoogleAuthProvider.credential(
          accessToken: _googleSignInAuthentication.accessToken,
          idToken: _googleSignInAuthentication.idToken
        );
        await _firebaseAuth.signInWithCredential(_oAuthCredential);
        notifyListeners();
      }
    }catch(e){
      print(e);
    }
  }

  Future<void> signUp() async {
    try{
      await signIn();
      User user = _firebaseAuth.currentUser;
      DocumentReference userRef = _firestore.collection('users').doc(user.uid);
      userRef.set({
        'uid' : user.uid,
        'google_id' : _googleSignIn.currentUser.id,
        'email' : user.email,
        'name' : user.displayName,
        'dailyTarget' : 2700
      });
      notifyListeners();
    }catch(e){
      print(e);
    }
  }

  void clearGoogleAccount()async{
    await _googleSignIn.signOut();
    notifyListeners();
  }

  void signOut() async {
    await _googleSignIn.signOut();
    await _firebaseAuth.signOut();
    notifyListeners();
  }
}