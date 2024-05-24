import 'package:EYA/models/complaint.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ComplaintService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<ComplaintModel>> fetchRandomComplaints(int limit) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
          .collection('sikayet')
          .where('isVisible', isEqualTo: true)
          .limit(limit)
          .get();

      List<ComplaintModel> complaints = querySnapshot.docs
          .map((doc) => ComplaintModel.fromFirestore(doc))
          .toList();

      return complaints;
    } catch (e) {
      print('Hata oluştu: $e');
      return [];
    }
  }

  Future<ComplaintModel?> fetchComplaintById(String id) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> docSnapshot =
          await _firestore.collection('sikayet').doc(id).get();

      if (docSnapshot.exists) {
        ComplaintModel complaint = ComplaintModel.fromFirestore(docSnapshot);
        return complaint;
      } else {
        return null;
      }
    } catch (e) {

      print('Hata oluştu: $e');
      return null;
    }
  }
}
