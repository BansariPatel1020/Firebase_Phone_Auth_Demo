import 'dart:io';
import 'package:flutter/material.dart';
import '../index.dart';

class ProfileBloc extends BaseBloc {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  String? image;
  String? prvImage;
  Validator validator = Validator();
  File? imgFile;
  var url;
  BehaviorSubject<bool> isUpdate = BehaviorSubject<bool>();

  Future<String> uploadGroupAvtar(File? imageFile) async {
    var url = imageFile != null
        ? await FirebaseManager.instance.uploadImage(imageFile)
        : '';
    return url;
  }

  void updateUserProfile() async {
    isLoading.add(true);
    image == null ? image = '' : image = image;
    try {
      if (imgFile == null) {
        DatabaseService(
            uid: formatePhoneToID(
          id: phoneNumberController.text,
        )).updateUserData(
          phoneNumberController.text,
          fullName: nameController.text,
          email: emailController.text,
          profilePic: image.toString(),
          address: addressController.text,
        );
        if ((prvImage ?? '').isNotEmpty) {
          await DatabaseService().deleteImageFromStorage(prvImage!);
        }
      } else {
        if (imgFile != null) {
          url = await uploadGroupAvtar(imgFile);
          image = url;
          DatabaseService(
              uid: formatePhoneToID(
            id: phoneNumberController.text,
          )).updateUserData(
            phoneNumberController.text,
            fullName: nameController.text,
            email: emailController.text,
            profilePic: url.toString(),
            address: addressController.text,
          );
        }
      }
      isLoading.add(false);
      imgFile = null;
      isUpdate.add(true);
    } catch (e) {
      errorSubject.add(e.toString());
      isUpdate.add(false);
    }
  }

  void deleteProfilePic() {
    prvImage = image;
    image = null;
  }
}
