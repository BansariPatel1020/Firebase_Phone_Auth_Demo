import '../index.dart';

class FireBaseAuthBloc {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<User?> getCurrentUser() async {
    var user = _firebaseAuth.currentUser;
    return user;
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  Future<bool> checkUserExists(String phoneNumber) async {
    final result = await DatabaseService()
        .getUserCollection()
        .where('phoneNumber', isEqualTo: phoneNumber)
        .get();
    final List<DocumentSnapshot> documents = result.docs;
    if (documents.isEmpty) {
      return false;
    } else {
      return true;
    }
  }
}
