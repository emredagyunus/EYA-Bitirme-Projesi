import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  //get instance of firebase auth
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  //get current user
  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }


  // sign in kurum
  Future<UserCredential> signInWithEmailPasswordKurum(
      String email, password) async {
    //try sign in user in
    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      return userCredential;
    }

    //catch any errors
    on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  
  //sign up kurum
  Future<UserCredential> signUpWithEmailPasswordKurum(
      String email, password, kurumname, il, ilce) async {

    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await userCredential.user?.sendEmailVerification();
      _firebaseAuth.signOut();

      final userDoc = FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid);

      await userDoc.set({
        'name': kurumname,
        'il': il,
        'ilce': ilce,
        'email': email,
        'password': password,
        'userID': userCredential.user!.uid,
      });

      return userCredential;
    } catch (e) {
      throw Exception('Sign up failed: $e');
    }
  }

  //sign out
  Future<void> signOut() async {
    return await _firebaseAuth.signOut();
  }
}
