import '../index.dart';

// import 'package:flutter_template/index.dart';
class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});
  CollectionReference getUserCollection() {
    return FirebaseFirestore.instance.collection('usersdevelopemet');
  }

  // update userdata
  Future updateUserData(
    String phoneNumber, {
    String? fullName,
    String? email,
    String? profilePic,
    String? address,
  }) async {
    final firebaseAuthBloc = FireBaseAuthBloc();
    var value = await firebaseAuthBloc.checkUserExists(phoneNumber);
    if (value) {
      await getUserCollection().doc(uid).update({
        'uid': uid,
        'fullName': fullName,
        'email': email,
        'token': AppManager.instance.firebaseToken,
        'profilePic': profilePic,
        'phone': phoneNumber,
        'address': address,
      });
    } else {
      await getUserCollection().doc(uid).set({
        'uid': uid,
        'fullName': fullName,
        'email': email,
        'token': AppManager.instance.firebaseToken,
        'profilePic': profilePic,
        'phone': phoneNumber,
        'address': address,
      });
    }
  }

  // get user data
  Future getUserData(String phone) async {
    var snapshot =
        await getUserCollection().where('phone', isEqualTo: phone).get();
    return snapshot;
  }

  Future deleteImageFromStorage(String url) async {
    var filePath = url.replaceAll(
        RegExp(
            r'https://firebasestorage.googleapis.com/v0/b/phoneotpauthdemo-1c0d9.appspot.com/o/'),
        '');

    filePath = filePath.replaceAll(RegExp(r'%2F'), '/');
    filePath = filePath.replaceAll(RegExp(r'(\?alt).*'), '');

    var storageReferance = FirebaseStorage.instance.ref();

    await storageReferance
        .child(filePath)
        .delete()
        .then((value) => print('Successfully deleted $filePath storage item'),
            onError: (value) {
      print('*error occured: $value*');
    });
  }
}
