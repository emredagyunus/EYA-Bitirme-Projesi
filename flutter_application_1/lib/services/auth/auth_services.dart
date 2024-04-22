import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  //get instance of firebase auth
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  //get current user
  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }

  //sign in
  Future<UserCredential> signInWithEmailPassword(String email, password) async {
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

  //sign up
  Future<UserCredential> signUpWithEmailPassword(String email, password,  name,  surname,  phone) async {
  try {
    // Kullanıcıyı e-posta ve şifre ile kaydet
    UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Yeni bir kullanıcı belgesi oluştur
    final userDoc = FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid);

    // Kullanıcı bilgilerini belgeye ekle
    await userDoc.set({
      'name': name,
      'surname': surname,
      'phone': phone,
      // Diğer kullanıcı bilgileri eklemek isterseniz burada ekleyebilirsiniz
    });

    return userCredential;
  } catch (e) {
    // FirebaseAuthException veya diğer hataları yakala
    throw Exception('Sign up failed: $e');
  }
}
  //sign out
  Future<void> signOut() async {
    return await _firebaseAuth.signOut();
  }
}
