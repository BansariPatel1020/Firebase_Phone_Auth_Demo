import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../index.dart';

enum PermissionAndFileTypes {
  camera,
  imgFromGallery,
  video,
  videoFromGallery,
  file,
  contacts
}

const cameraAccessDenied = 'camera_access_denied';
const photoAccessDenied = 'photo_access_denied';
const readExternalStorageDenied = 'read_external_storage_denied';
const fileExceptionDueToStoragePermissionErrorCode = 13;
const contactsAccessDenied = 'contacts_access_denied';

class PermissionManager {
  Future<String> getDevicePermissionAndFiles(
      {required BuildContext context,
      required PermissionAndFileTypes type,
      List<String>? allowedExtensions}) async {
    final picker = ImagePicker();
    var filePath = '';
    try {
      switch (type) {
        case PermissionAndFileTypes.camera:
          final pickedFile = await picker.pickImage(source: ImageSource.camera);
          filePath = pickedFile?.path ?? '';
          break;
        case PermissionAndFileTypes.imgFromGallery:
          final pickedFile =
              await picker.pickImage(source: ImageSource.gallery);
          filePath = pickedFile?.path ?? '';
          break;
        default:
          showBoatToast('did_not_get_file_type');
          break;
      }
    } on PlatformException catch (e) {
      if (e.code == cameraAccessDenied) {
        showDialogForSetting(context, 'camera_permission_string');
      } else if (e.code == photoAccessDenied ||
          e.code == readExternalStorageDenied) {
        showDialogForSetting(context, 'storage_permission_string');
      } else if (e.code == contactsAccessDenied) {
        showDialogForSetting(context, 'contact_permission_string');
      } else {
        showBoatToast('${e.message}');
      }
    } catch (e) {
      showBoatToast(e.toString());
    }
    return filePath;
  }
}
