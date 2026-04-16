import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Get the current company tied to a specific uid.
  Stream<Map<String, dynamic>?> getCompanyStream(String uid) {
    return _db
        .collection('companies')
        .where('ownerUid', isEqualTo: uid)
        .limit(1)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.isNotEmpty ? snapshot.docs.first.data() : null);
  }

  /// Create or update company data
  Future<void> saveCompanyProfile({
    required String uid,
    required String pan,
    required String name,
    required String type,
    required String turnover,
    required String natureOfBusiness,
    required List<String> subCategories,
    required String gst,
    required String gstStatus,
    required String udyam,
    required String dsc,
  }) async {
    // Determine document id based on PAN if single-company pattern, or a generated one.
    // Using uid mapping directly since we map 1:1 user to company for MVP.
    // Could also just store under ownerUid as the ID or generate random.
    QuerySnapshot existing = await _db
        .collection('companies')
        .where('ownerUid', isEqualTo: uid)
        .limit(1)
        .get();

    String docId = existing.docs.isNotEmpty
        ? existing.docs.first.id
        : _db.collection('companies').doc().id;

    await _db.collection('companies').doc(docId).set({
      'ownerUid': uid,
      'pan': pan,
      'name': name,
      'type': type,
      'turnover': turnover,
      'natureOfBusiness': natureOfBusiness,
      'subCategories': subCategories,
      'gst': gst,
      'gstStatus': gstStatus,
      'udyam': udyam,
      'dsc': dsc,
      'bhsScore': 78, // Initial mock score
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  /// Update company BHS directly
  Future<void> updateBHS(String companyDocId, int score) async {
    await _db
        .collection('companies')
        .doc(companyDocId)
        .update({'bhsScore': score, 'lastCalculated': FieldValue.serverTimestamp()});
  }
}
