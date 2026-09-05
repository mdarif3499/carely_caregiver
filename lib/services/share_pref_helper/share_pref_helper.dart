import 'package:carely_caregiver/services/socket/socket_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceValue {
  static const String searchHistory = "searchHistory";
  static const String token = "token";
  static const String refreshToken = "refreshToken";
  static const String email = "email";
  static const String userId = "userId";
  static const String isRemember = "isRemember";
  static const String isOnboarding = "isOnboarding";
  static const String fcmToken = "fcmToken";
  static const String language = "language";
  static const String role = "role";
  static const String teacherType = "teacherType";
  static const String number = "number";
  static const String password = "password";
  static const String phone = "phone";
  static const String workshopId = "workshopId";
  static const String contactNumber = "contactNumber";
  static const String subscriptionId = "subscriptionId";
  static const String carSymbolList = "carSymbolList";
  static const String carBrandList = "carBrandList";
  static const String prefsKey = 'selected_country_ids';
  static const String prefsKeyWorkShop = 'selected_workshopwork_ids';
}

class SharePrefsHelper {
  static SharedPreferences? _preferences;

  static Future<void> init() async {
    _preferences ??= await SharedPreferences.getInstance();
  }

  //===========================Get Data From Shared Preference===================
  static Future<String> getString(String key) async {
    await init();
    return _preferences!.getString(key) ?? "";
  }

  static Future<List<String>> getLisOfString(String key) async {
    await init();
    final getListData = _preferences!.getStringList(key);

    return getListData ?? [];
  }

  static Future<bool?> getBool(String key) async {
    await init();
    return _preferences!.getBool(key);
  }

  static Future<int> getInt(String key) async {
    await init();
    return _preferences!.getInt(key) ?? (-1);
  }

  //===========================Save Data To Shared Preference===================

  static Future setString(String key, value) async {
    await init();
    await _preferences!.setString(key, value);
  }

  static Future<bool> setListOfString(String key, List<String> value) async {
    await init();
    var setListData = await _preferences!.setStringList(key, value);

    return setListData;
  }

  static Future setBool(String key, bool value) async {
    await init();
    await _preferences!.setBool(key, value);
  }

  static Future setInt(String key, int value) async {
    await init();
    await _preferences!.setInt(key, value);
  }

  static clearData() async {
    SharePrefsHelper.remove(SharedPreferenceValue.workshopId);
    SharePrefsHelper.remove(SharedPreferenceValue.token);
    SharePrefsHelper.remove(SharedPreferenceValue.refreshToken);
    SharePrefsHelper.remove(SharedPreferenceValue.userId);
    SharePrefsHelper.remove(SharedPreferenceValue.role);
    SharePrefsHelper.remove(SharedPreferenceValue.email);
    SharePrefsHelper.remove(SharedPreferenceValue.phone);
    SharePrefsHelper.remove(SharedPreferenceValue.searchHistory);

    // Disconnect WebSocket on logout
    SocketService.disconnect();
  }

  //===========================Remove Value===================

  static Future remove(String key) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.remove(key);
  }
}
