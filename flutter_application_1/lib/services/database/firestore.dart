import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreServices {
  //get collection of orders
  final CollectionReference orders =
      FirebaseFirestore.instance.collection('orders');

  // save order db
  Future<void> saveOrderToDatabase(String receipt) async {
    await orders.add({
      'date': DateTime.now(),
      'oreder': receipt,
      //add more fields as necessary
    });
  }
}
