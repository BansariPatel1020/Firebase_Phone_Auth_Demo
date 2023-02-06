import 'dart:io';
import '../index.dart';

class FirebaseManager {
  FirebaseManager._(); //private constructor
  static final FirebaseManager instance = FirebaseManager._();

  Future<String> uploadImage(File imageFile) async {
    var firebaseStorage = FirebaseStorage.instance;
    var fileName = DateTime.now().millisecondsSinceEpoch.toString();
    var reference = firebaseStorage.ref().child(fileName);

    var compressedFile = await FlutterNativeImage.compressImage(imageFile.path,
        quality: 80, percentage: 90);
    var uploadTask = await reference.putFile(compressedFile);
    return uploadTask.ref.getDownloadURL().then((downloadUrl) {
      return downloadUrl;
    });
  }
}
