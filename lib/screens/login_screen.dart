import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../index.dart';

class LoginScreen extends BaseView {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends BaseViewState<LoginScreen> with BasePage {
  final LoginBloc _loginBloc = LoginBloc();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initBaseState() {
    leftAppBarButton = LeftAppBarButton.empty;
    isSafeAreaRequire = true;
    titleScreen = 'Login';

    attachListener();
  }

  void attachListener() {
    _loginBloc.errorSubject.listen((error) {
      showErrorMessage(error, scaffoldKey.currentState!);
    });

    _loginBloc.isLoading.listen((value) {
      if (value) {
        showIndicator('Loading...', scaffoldKey.currentState!);
      } else {
        hideIndicator(scaffoldKey.currentState!);
      }
    });

    _loginBloc.otpCode.listen((value) {
      if (value.isNotEmpty) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) {
          return OtpScreen(
            arguments: OtpScreenArguments(
                id: value, mobile: _loginBloc.mobileController.text),
          );
        }));
      } else {
        _loginBloc.errorSubject.add('');
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _loginBloc.dispose();
  }

  @override
  Widget body() {
    return ResponsiveWidget(
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
                  //   ImagePath.login,
                  //   height: 300,
                  //   // color: pinkColor,
                  // ),
                  Lottie.asset('assets/images/phone_login.json'),
                  const SizedBox(height: 32),
                  CustomTextFormField(
                    label: 'Enter your mobile number',
                    controller: _loginBloc.mobileController,
                    keyboardType: TextInputType.number,
                    textInputFormatter: FilteringTextInputFormatter.digitsOnly,
                    showPasswordToggleIcon: false,
                    onSubmitted: (value) {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                      }
                    },
                    validator: (value) {
                      var result =
                          _loginBloc.validator.validateMobile(value ?? '');
                      if (result != '') {
                        return result;
                      }
                      return null;
                    },
                  ),
                  verticalSizedBox24,
                  CustomRaisedButton(
                    buttonWidth: commonButtonWidth,
                    text: 'Get OTP',
                    onCustomButtonPressed: () {
                      _loginBloc.mobile = _loginBloc.mobileController.text;
                      _onSignInPressed();
                    },
                  ),
                  verticalSizedBox32,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onSignInPressed() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      await _loginBloc.verifyPhoneNumber();
    }
  }
}
