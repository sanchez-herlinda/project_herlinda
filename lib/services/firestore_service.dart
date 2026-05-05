import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/personal_model.dart';

class FirestoreService {
  final CollectionReference _db = FirebaseFirestore.instance.collection(
    'personal',
  );

  Stream<List<PersonalModel>> getPersonal() {
    return _db.snapshots().map(
      (snapshot) =>
          snapshot.docs.map((doc) => PersonalModel.fromFirestore(doc)).toList(),
    );
  }

  Future<void> addPersonal(PersonalModel p) => _db.add(p.toJson());
  Future<void> updatePersonal(PersonalModel p) =>
      _db.doc(p.id).update(p.toJson());
  Future<void> deletePersonal(String id) => _db.doc(id).delete();
}
