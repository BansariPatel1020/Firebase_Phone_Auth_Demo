import 'dart:convert';
import '../index.dart';

class HelperFunctions {
  HelperFunctions._();
  static final HelperFunctions instance = HelperFunctions._();

  static String sharedPreferenceUserLoggedInKey = 'ISLOGGEDIN';
  static String sharedPreferenceUserMobileKey = 'USERMOBILEKEY';
  static String _sharedPreferenceUserProfileKey = "USERPROFILEKEY";

  Future<void> saveUserprofileSharedPreference(UserModel value) async {
    try {
      var preference = await SharedPreferences.getInstance();
      preference.setString(_sharedPreferenceUserProfileKey, json.encode(value));
    } catch (e) {
      print(e.toString());
    }
  }

  // saving data to sharedpreference
  static Future<bool> saveUserLoggedInSharedPreference(
      bool isUserLoggedIn) async {
    var preferences = await SharedPreferences.getInstance();
    return await preferences.setBool(
        sharedPreferenceUserLoggedInKey, isUserLoggedIn);
  }

  static Future<bool> saveUserMobileSharedPreference(String userMobile) async {
    var preferences = await SharedPreferences.getInstance();
    return await preferences.setString(
        sharedPreferenceUserMobileKey, userMobile);
  }

  // fetching data from sharedpreference
  static Future<bool> getUserLoggedInSharedPreference() async {
    var preferences = await SharedPreferences.getInstance();
    return preferences.getBool(sharedPreferenceUserLoggedInKey) ?? false;
  }

  static Future<String> getUserMobileSharedPreference() async {
    var preferences = await SharedPreferences.getInstance();
    return preferences.getString(sharedPreferenceUserMobileKey) ?? '';
  }

  static Future<UserModel?> getUserProfileSharedPreference() async {
    var preferences = await SharedPreferences.getInstance();
    if ((preferences.getString(_sharedPreferenceUserProfileKey) ?? '')
        .isNotEmpty) {
      return UserModel.fromJson(json.decode(
          preferences.getString(_sharedPreferenceUserProfileKey) ?? ''));
    } else {
      return null;
    }
  }
}
