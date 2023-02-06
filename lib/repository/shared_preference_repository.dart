import '../index.dart';

const _preferenceKeyLoggedIn = 'keyLoggedIn';

class SharedPreferenceRepository {
  Future<SharedPreferences> getSharedPrefInstance() async {
    var sharedPreferences =
        await SharedPreferences.getInstance().then((value) => value);
    return sharedPreferences;
  }

  /// Saves LoggedIn status in shared preference
  void saveLoggedIn(bool value) {
    AppManager.sharedPreferences!.setBool(_preferenceKeyLoggedIn, value);
  }

  /// Gets LoggedIn status from shared preference
  bool isLoggedIn() {
    return AppManager.sharedPreferences!.getBool(_preferenceKeyLoggedIn) ??
        false;
  }
}
