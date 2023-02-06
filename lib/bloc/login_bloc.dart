import 'package:flutter/material.dart';
import '../index.dart';
// import 'package:sms_autofill/sms_autofill.dart';

class LoginBloc extends BaseBloc {
  TextEditingController mobileController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  Validator validator = Validator();
  BehaviorSubject<String> otpCode = BehaviorSubject<String>();
  BehaviorSubject<UserCredential> userCredentialsResponse =
      BehaviorSubject<UserCredential>();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  var verificationIdReceived = '';
  var mobile = '';
  var sendOtpId = '';
  var codeValue = "";

  Future<void> verifyPhoneNumber() async {
    isLoading.add(true);
    var number = '+91$mobile';
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: number,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {},
        verificationFailed: (FirebaseAuthException e) async {
          isLoading.add(false);
          switch (e.code) {
            case "network-request-failed":
              {
                errorSubject.add("No internet, Check your connectivity!");
              }
              break;
            case "too-many-requests":
              {
                errorSubject.add("You have tried too many attempts");
              }
              break;
            default:
              {
                errorSubject.add("Something went wrong, Please try again!");
              }
              break;
          }
        },
        codeSent: (String verificationId, int? resendToken) async {
          verificationIdReceived = verificationId;
          isLoading.add(false);
          otpCode.add(verificationIdReceived);
          sendOtpId = verificationIdReceived;
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          // Auto-resolution timed out...
          if (isLoading.value) {
            isLoading.add(false);
          }
        },
      );
    } on FirebaseAuthException catch (e) {
      isLoading.add(false);
      switch (e.code) {
        case "network-request-failed":
          {
            errorSubject.add("No internet, Check your connectivity!");
          }
          break;
        default:
          {
            errorSubject.add("Something went wrong, Please try again!");
          }
          break;
      }
    }
  }

  void verifyOTP(BuildContext context) async {
    isLoading.add(true);
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: sendOtpId, smsCode: otpController.text);

    try {
      // await FirebaseAuth.instance.signInWithCredential(credential);

      // var currentUser = FirebaseAuth.instance.currentUser;
      // DatabaseService(
      //         uid: formatePhoneToID(
      //   id: '${currentUser?.phoneNumber}',
      // ))
      //     .updateUserData(
      //   '${currentUser?.phoneNumber}',
      // )
      //     .then((value) async {
      //   await HelperFunctions.saveUserMobileSharedPreference(
      //       currentUser?.phoneNumber ?? '');
      //   Navigator.pushReplacementNamed(context, profileScreen);
      // });
      // isLoading.add(false);

      var response =
          await FirebaseAuth.instance.signInWithCredential(credential);

      var currentUser = FirebaseAuth.instance.currentUser;

      QuerySnapshot userInfoSnapshot =
          await DatabaseService().getUserData('${currentUser?.phoneNumber}');

      if (userInfoSnapshot.docs.isNotEmpty) {
        Map<String, dynamic> map =
            (userInfoSnapshot.docs.first.data() as Map<String, dynamic>);
        var user = UserModel.fromJson(map);

        await HelperFunctions.instance.saveUserprofileSharedPreference(user);

        await HelperFunctions.saveUserMobileSharedPreference('${user.phone}');
        // await HelperFunctions.saveUserNameSharedPreference('${user.fullName}');
      } else {
        DatabaseService(
            uid: formatePhoneToID(
          id: '${currentUser?.phoneNumber}',
        )).updateUserData(
          '${currentUser?.phoneNumber}',
        );
        await HelperFunctions.saveUserMobileSharedPreference(
            '${currentUser?.phoneNumber}');
      }
      isLoading.add(false);
      userCredentialsResponse.add(response);
      // await Navigator.pushReplacementNamed(context, profileScreen);
    } on FirebaseAuthException catch (e) {
      isLoading.add(false);
      switch (e.code) {
        case "invalid-verification-code":
          {
            errorSubject.add("Invalid OTP!, Check Your OTP!");
          }
          break;
        case "user-disabled":
          {
            errorSubject.add("User is disable by Admin");
          }
          break;
        case "network-request-failed":
          {
            errorSubject.add("No internet, Check your connectivity!");
          }
          break;
        case "session-expired":
          {
            errorSubject.add("Session expired. Please login again.");
          }
          break;
        default:
          {
            errorSubject.add("Something went wrong, Please try again!");
          }
          break;
      }
    } catch (e) {
      isLoading.add(false);
      errorSubject.add(e.toString());
    }
  }

  void onResend() {
    verifyPhoneNumber();
  }

  @override
  void dispose() {
    isLoading.close();
    errorSubject.close();
    otpCode.close();
  }
}
