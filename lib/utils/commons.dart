import 'dart:io';

import 'package:flutter/material.dart';
import '../index.dart';

void showBoatToast(String message, {bool? hideButton}) {
  BotToast.cleanAll();

  BotToast.showAnimationWidget(
    backgroundColor: Colors.transparent,
    duration: const Duration(seconds: 10),
    animationDuration: const Duration(milliseconds: 100),
    toastBuilder: (_) => SafeArea(
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(left: 16, right: 16, top: 16),
        padding: const EdgeInsets.only(left: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 2),
          borderRadius: BorderRadius.circular(32),
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: pinkThemeGradientColors,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 8),
                child: Text(
                  message,
                  key: const Key('BotToastText'),
                  style: TextStyle(color: white, fontWeight: FontWeight.bold),
                  softWrap: true,
                  overflow: TextOverflow.fade,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Visibility(
              visible: hideButton ?? false,
              child: TextButton(
                onPressed: () {
                  BotToast.cleanAll();
                },
                style: TextButton.styleFrom(
                  backgroundColor: white,
                  disabledForegroundColor: grey,
                  side: BorderSide(color: white),
                ),
                child: const Text(
                  'Hide',
                  // style: TextStyle(color: white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            MaterialButton(
              key: const Key('BotToastMaterialButton'),
              minWidth: 0.0,
              padding: EdgeInsets.zero,
              onPressed: () {
                BotToast.cleanAll();
              },
              child: Icon(
                Icons.cancel,
                color: white,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

/// Show Progress Dialog
void showProgressDialog(String text, BuildContext context) {
  try {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Dialog(
              elevation: 0.0,
              backgroundColor: Colors.transparent,
              child: Stack(children: <Widget>[
                Center(
                  child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(componentPadding),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10.0,
                            offset: Offset(0.0, 10.0),
                          ),
                        ],
                      ),
                      child: Container(
                        margin: const EdgeInsets.all(margin),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              CircularProgressIndicator(
                                color: pinkColor,
                              ),
                              const SizedBox(
                                height: margin,
                              ),
                              Text(
                                text,
                                style: black16TextFieldStyle(),
                              )
                            ]),
                      )),
                )
              ]));
        });
  } catch (e) {
    print(e.toString());
  }
}

/// Hides Progress dialog
void hideProgressDialog(BuildContext context) {
  Navigator.pop(context);
}

Future<File?> getImage(BuildContext context) async {
  var data = await PermissionManager().getDevicePermissionAndFiles(
    context: context,
    type: PermissionAndFileTypes.camera,
  );
  if (data.isNotEmpty) {
    return await _cropImage(data, context);
  } else {
    print('No image captured.');
    return null;
  }
}

Future<File?> getImageFromGallery(BuildContext context) async {
  var data = await PermissionManager().getDevicePermissionAndFiles(
    context: context,
    type: PermissionAndFileTypes.imgFromGallery,
  );
  if (data.isNotEmpty) {
    return await _cropImage(data, context);
  } else {
    print('No image selected.');
    return null;
  }
}

Future<File?> _cropImage(String path, BuildContext context) async {
  var croppedFile = await ImageCropper().cropImage(
    uiSettings: [
      AndroidUiSettings(
        toolbarTitle: 'Edit Image',
        toolbarColor: appBarBackground,
        toolbarWidgetColor: pinkColor,
        initAspectRatio: CropAspectRatioPreset.square,
        lockAspectRatio: true,
        activeControlsWidgetColor: pinkColor,
      ),
      IOSUiSettings(
        title: 'Edit Image',
      ),
    ],
    sourcePath: path,
    aspectRatioPresets: Platform.isAndroid
        ? [
            CropAspectRatioPreset.square,
          ]
        : [
            CropAspectRatioPreset.square,
          ],
    // androidUiSettings: AndroidUiSettings(
    //   toolbarTitle: AppLocalizations.instance?.translate('cropImage'),
    //   toolbarColor: appBarBackground,
    //   toolbarWidgetColor: pinkColor,
    //   initAspectRatio: CropAspectRatioPreset.square,
    //   lockAspectRatio: true,
    //   activeControlsWidgetColor: pinkColor,
    // ),
    // iosUiSettings: IOSUiSettings(
    //   title: AppLocalizations.instance?.translate('cropImage'),
    // ),
  );
  if (croppedFile != null) {
    return File(croppedFile.path);
  } else {
    return null;
  }
}

Widget profilePlaceholder() {
  return SvgPicture.asset(
    ImagePath.profileplaceholder,
    color: grey,
  );
}

Future<void> showDialogForSetting(BuildContext context, String msg) async {
  showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
            content: Text(msg),
            actions: <Widget>[
              MaterialButton(
                key: Key('PermissionManager_DialogForSetting_${msg}_cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
              MaterialButton(
                key: Key('PermissionManager_DialogForSetting_${msg}_settings'),
                onPressed: () async {
                  await openAppSettings();

                  // Navigator.of(context).pop();
                },
                child: const Text('Settings'),
              ),
            ],
          ));
}

String formatePhoneToID({required String id}) {
  id = id.replaceAll(RegExp(r'[^0-9]'), '');

  if (id.length == 10) {
    id = '91$id';
    return id;
  } else if (id.length == 11) {
    var re = RegExp(r'\d{1}'); // replace two digits
    id = id.replaceFirst(re, '+91');
    return id;
  } else {
    return id;
  }
}
