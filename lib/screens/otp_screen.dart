import 'dart:async';
import 'package:alt_sms_autofill/alt_sms_autofill.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../index.dart';

class OtpScreenArguments {
  final String id;
  final String mobile;

  OtpScreenArguments({required this.id, required this.mobile});
}

class OtpScreen extends BaseView {
  final OtpScreenArguments arguments;

  const OtpScreen({super.key, required this.arguments});
  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends BaseViewState<OtpScreen> with BasePage {
  final LoginBloc _otpBloc = LoginBloc();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int secondsRemaining = 60;
  bool enableResend = false;
  Timer? timer;

  @override
  void initBaseState() {
    // isHiddenNavigationBar = true;

    leftAppBarButton = LeftAppBarButton.empty;
    isSafeAreaRequire = false;
    titleScreen = 'OTP';

    _otpBloc.sendOtpId = widget.arguments.id;
    _otpBloc.mobile = widget.arguments.mobile;

    initSmsListener();

    _otpBloc.userCredentialsResponse.listen((value) {
      HelperFunctions.saveUserLoggedInSharedPreference(true);
      Navigator.pushReplacementNamed(context, profileScreen);
    });

    _otpBloc.errorSubject.listen((error) {
      showErrorMessage(error, scaffoldKey.currentState!);
    });

    _otpBloc.isLoading.listen((value) {
      if (value) {
        showIndicator('Loading...', scaffoldKey.currentState!);
      } else {
        hideIndicator(scaffoldKey.currentState!);
      }
    });

    _otpBloc.otpCode.listen((value) {
      if (value.isNotEmpty) {
        secondsRemaining = 60;
        enableResend = false;
      } else {
        _otpBloc.errorSubject.add('');
      }
    });

    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (secondsRemaining != 0) {
        setState(() {
          secondsRemaining--;
        });
      } else {
        setState(() {
          enableResend = true;
        });
      }
    });
  }

  @override
  Widget body() {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) {
          return const LoginScreen();
        }));
        return true;
      },
      child: ResponsiveWidget(
        smallScreen: Form(
          key: _formKey,
          child: Center(
            child: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.all(15.0),
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: <Widget>[
                    // Image.asset(
                    //   ImagePath.otp,
                    //   height: 100,
                    //   color: pinkColor,
                    // ),
                    Lottie.asset('assets/images/otp.json'),
                    const SizedBox(height: 32),
                    PinCodeTextField(
                      appContext: context,
                      pastedTextStyle: TextStyle(
                        color: Colors.green.shade600,
                        fontWeight: FontWeight.bold,
                      ),
                      length: 6,
                      obscureText: false,
                      animationType: AnimationType.fade,
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(10),
                        fieldHeight: 50,
                        fieldWidth: 40,
                        inactiveFillColor: Colors.white,
                        inactiveColor: blueGrey,
                        selectedColor: blueGrey,
                        selectedFillColor: Colors.white,
                        activeFillColor: Colors.white,
                        activeColor: blueGrey,
                      ),
                      cursorColor: Colors.black,
                      animationDuration: const Duration(milliseconds: 300),
                      enableActiveFill: true,
                      controller: _otpBloc.otpController,
                      keyboardType: TextInputType.number,
                      boxShadows: const [
                        BoxShadow(
                          offset: Offset(0, 1),
                          color: Colors.black12,
                          blurRadius: 10,
                        )
                      ],
                      onCompleted: (v) {
                        //do something or move to next screen when code complete
                      },
                      onChanged: (value) {
                        // debugPrint(value);
                      },
                    ),
                    verticalSizedBox16,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Didn\'t received OTP?',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        horizontalSizedBox8,
                        enableResend
                            ? TextButton(
                                onPressed: () {
                                  setState(() {
                                    _otpBloc.onResend();
                                  });
                                },
                                child: const Text('Resend OTP'),
                              )
                            : Text(
                                'Resend in $secondsRemaining s',
                                // style: TextStyle(color: Colors.white, fontSize: 10),
                              ),
                      ],
                    ),
                    verticalSizedBox8,
                    CustomRaisedButton(
                      text: 'Login',
                      onCustomButtonPressed: () {
                        if (_otpBloc.otpController.text.length == 6) {
                          _onSignInPressed();
                        } else {
                          _otpBloc.errorSubject.add('Invalid OTP!');
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
    _otpBloc.dispose();
    AltSmsAutofill().unregisterListener();
  }

  void _onSignInPressed() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      _otpBloc.verifyOTP(context);
    }
  }

  Future<void> initSmsListener() async {
    String? comingSms;
    try {
      comingSms = await AltSmsAutofill().listenForSms;
    } on PlatformException {
      comingSms = 'Failed to get Sms.';
    }
    if (!mounted) return;

    setState(() {
      _otpBloc.codeValue = (comingSms ?? '').substring(0, 6);
      _otpBloc.otpController.text = _otpBloc.codeValue;
      _otpBloc.verifyOTP(context);
    });
  }
}
