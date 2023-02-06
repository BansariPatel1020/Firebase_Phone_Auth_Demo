class Validator {
  String validateName(String value) {
    var pattern = r'(^[a-zA-Z ]*$)';
    var regExp = RegExp(pattern);
    if (value.isEmpty) {
      return 'Name is Required';
    } else if (!regExp.hasMatch(value)) {
      return 'Name must be a-z and A-Z';
    }
    return '';
  }

  String validateOtp(String value) {
    var pattern = r'(^[0-9]*$)';
    var regExp = RegExp(pattern);
    if (value.isEmpty) {
      return 'OTP is Required';
    } else if (value.length != 6) {
      return 'OTP must be 6 digits';
    } else if (!regExp.hasMatch(value)) {
      return 'OTP must be digits';
    }
    return '';
  }

  String validateMobile(String value) {
    var pattern = r'(^[0-9]*$)';
    var regExp = RegExp(pattern);
    if (value.isEmpty) {
      return 'Mobile number is Required';
    } else if (value.length != 10) {
      return 'Mobile number must be 10 digits';
    } else if (!regExp.hasMatch(value)) {
      return 'Mobile Number must be digits';
    }
    return '';
  }

  String validateEmail(String value) {
    var pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    var regExp = RegExp(pattern);
    if (value.isEmpty || value == '') {
      return 'Email is required';
    } else if (!regExp.hasMatch(value)) {
      return 'Please enter valid email';
    } else {
      return '';
    }
  }
}
