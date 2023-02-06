import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../index.dart';

class ProfilePage extends BaseView {
  ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends BaseViewState<ProfilePage> with BasePage {
  final ProfileBloc _profileBloc = ProfileBloc();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late bool isEdit;
  final picker = ImagePicker();
  UserModel? user;

  Widget getProfilePic() {
    if (_profileBloc.imgFile == null) {
      if ((_profileBloc.image ?? '').isNotEmpty) {
        return CachedNetworkImage(imageUrl: _profileBloc.image!);
      } else {
        return Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: grey,
              width: 2,
            ),
            borderRadius: const BorderRadius.all(
              Radius.circular(100),
            ),
          ),
          child: profilePlaceholder(),
        );
      }
    } else {
      if (_profileBloc.imgFile != null) {
        return Image.file(_profileBloc.imgFile!);
      } else {
        return Container();
      }
    }
  }

  @override
  void initBaseState() async {
    isEdit = true;

    isSafeAreaRequire = true;
    titleScreen = 'Profile';

    leftAppBarButton = LeftAppBarButton.empty;
    rightAppBarButton = RightAppBarButton.logout;

    user = await HelperFunctions.getUserProfileSharedPreference();
    if (user == null) {
      var phone = await HelperFunctions.getUserMobileSharedPreference();
      QuerySnapshot userInfoSnapshot = await DatabaseService(
          uid: formatePhoneToID(
        id: phone,
      )).getUserData(phone);

      print(userInfoSnapshot);

      if (userInfoSnapshot.docs.isNotEmpty) {
        Map<String, dynamic> map =
            (userInfoSnapshot.docs.first.data() as Map<String, dynamic>);
        var userModel = UserModel.fromJson(map);

        await HelperFunctions.instance
            .saveUserprofileSharedPreference(userModel);

        await HelperFunctions.saveUserMobileSharedPreference(
            '${userModel.phone}');

        _profileBloc.phoneNumberController.text = userModel.phone ?? '';
        _profileBloc.nameController.text = userModel.fullName ?? '';
        _profileBloc.emailController.text = userModel.email ?? '';
        _profileBloc.addressController.text = userModel.address ?? '';
        _profileBloc.image = userModel.profilePic;
      }
    } else {
      setState(() {
        _profileBloc.phoneNumberController.text = user?.phone ?? '';
        _profileBloc.nameController.text = user?.fullName ?? '';
        _profileBloc.emailController.text = user?.email ?? '';
        _profileBloc.addressController.text = user?.address ?? '';
        _profileBloc.image = user?.profilePic;
      });
    }

    _profileBloc.errorSubject.listen((error) {
      showErrorMessage(error, scaffoldKey.currentState!);
    });

    _profileBloc.isLoading.listen((value) {
      if (value) {
        showIndicator('Loading...', scaffoldKey.currentState!);
      } else {
        hideIndicator(scaffoldKey.currentState!);
      }
    });
  }

  @override
  void dispose() {
    _profileBloc.nameController.dispose();
    _profileBloc.emailController.dispose();
    _profileBloc.phoneNumberController.dispose();
    _profileBloc.addressController.dispose();
    _profileBloc.dispose();
    super.dispose();
  }

  @override
  Widget body() {
    return Container(
      height: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
            child: Column(
              children: [
                Center(
                  child: Stack(
                    children: [
                      Center(
                        child: IgnorePointer(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: SizedBox(
                              height: 150,
                              width: 150,
                              child: getProfilePic(),
                            ),
                          ),
                        ),
                      ),
                      // Photo edit icon
                      Center(
                        child: SizedBox(
                          width: 150,
                          height: 150,
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: white,
                                ),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(50),
                                ),
                                color: white.withOpacity(0.7),
                              ),
                              padding: const EdgeInsets.all(5),
                              margin: const EdgeInsets.all(10),
                              child: isEdit
                                  ? InkWell(
                                      onTap: () async {
                                        await showCameraOrGalleryPickerDialog(
                                          context,
                                        );
                                      },
                                      child: Icon(
                                        Icons.camera,
                                        color: iconFillColor,
                                      ),
                                    )
                                  : InkWell(
                                      onTap: () {
                                        isEdit = !isEdit;
                                        setState(() {});
                                      },
                                      child: Icon(
                                        Icons.edit,
                                        color: iconFillColor,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                verticalSizedBox32,
                CustomTextFormField(
                  label: 'Name',
                  controller: _profileBloc.nameController,
                  textCapitalization: TextCapitalization.words,
                  onSubmitted: (value) {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                    }
                  },
                  validator: (value) {
                    var result =
                        _profileBloc.validator.validateName(value ?? '');
                    if (result != '') {
                      return result;
                    }
                    return null;
                  },
                  enabled: isEdit ? true : false,
                ),
                const SizedBox(height: 24),
                CustomTextFormField(
                  label: 'Phone no.',
                  controller: _profileBloc.phoneNumberController,
                  enabled: false,
                ),
                const SizedBox(height: 24),
                CustomTextFormField(
                  label: 'Email',
                  controller: _profileBloc.emailController,
                  keyboardType: TextInputType.emailAddress,
                  onSubmitted: (value) {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      // _profileBloc.updateUserProfile();
                    }
                  },
                  validator: (value) {
                    var result =
                        _profileBloc.validator.validateEmail(value ?? '');
                    if (result != '') {
                      return result;
                    }
                    return null;
                  },
                  enabled: isEdit ? true : false,
                ),
                const SizedBox(height: 24),
                CustomTextFormField(
                  label: 'Address',
                  controller: _profileBloc.addressController,
                  maxLine: null,
                  enabled: isEdit ? true : false,
                  keyboardType: TextInputType.multiline,
                ),
                verticalSizedBox8,
                Visibility(
                  visible: isEdit,
                  child: Row(
                    children: [
                      Flexible(
                        flex: 50,
                        child: CustomRaisedButton(
                          text: 'Save',
                          onCustomButtonPressed: () {
                            isEdit = !isEdit;
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              _profileBloc.updateUserProfile();
                            }
                            setState(() {});
                          },
                        ),
                      ),
                      horizontalSizedBox16,
                      Flexible(
                        flex: 50,
                        child: CustomRaisedButton(
                          text: 'Cancel',
                          onCustomButtonPressed: () {
                            onCancelButtonPressed();
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onCancelButtonPressed() {
    setState(() {
      isEdit = !isEdit;
      _formKey.currentState?.reset();
      _profileBloc.imgFile = null;
      _profileBloc.prvImage = null;
      _profileBloc.nameController.text = user?.fullName ?? '';
      _profileBloc.emailController.text = user?.email ?? '';
      _profileBloc.phoneNumberController.text = user?.phone ?? '';
      _profileBloc.addressController.text = user?.address ?? '';
      // _profileBloc.imgFile = File(user?.profilePic ?? '');
      _profileBloc.image = user?.profilePic;
    });
  }

  /// Show Camera and Gallery picker dialog
  Future showCameraOrGalleryPickerDialog(BuildContext context) async {
    await showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          title: const Text('Pick Image Source'),
          cancelButton: CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          actions: [
            CupertinoActionSheetAction(
              onPressed: () async {
                Navigator.pop(context);
                var newFile = await getImage(context);
                _profileBloc.imgFile = newFile ?? _profileBloc.imgFile;
                setState(() {});
              },
              child: const Text('Take a New Picture'),
            ),
            CupertinoActionSheetAction(
              onPressed: () async {
                Navigator.pop(context);
                var newFile = await getImageFromGallery(context);
                _profileBloc.imgFile = newFile ?? _profileBloc.imgFile;
                setState(() {});
              },
              child: const Text('Select Picture from library'),
            ),
            Visibility(
              visible: (_profileBloc.image ?? '').isNotEmpty,
              child: CupertinoActionSheetAction(
                onPressed: () async {
                  Navigator.pop(context);
                  _profileBloc.deleteProfilePic();
                  setState(() {});
                  _profileBloc.imgFile = null;
                },
                child: const Text(
                  'Delete Picture',
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
