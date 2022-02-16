import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {

  static String userIdKey = "USERKEY";
  static String userNameKey = "USERNAMEKEY";
  static String displayNameKey = "USERDISPLAYNAMEKEY";
  static String userEmailKey =  "USEREMAILKEY";
  static String userProfileKey = "USERPROFILEKEY";

  // NOTE: I think the following code can be optimized to a single function with a switch case
  // Saving data with sharedPreferences
  saveUserName(String getUserName) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString(userIdKey, getUserName);
  }
   
}
