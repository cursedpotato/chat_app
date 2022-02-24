import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {

  static String userIdKey = "USERKEY";
  static String userNameKey = "USERNAMEKEY";
  static String displayNameKey = "USERDISPLAYNAMEKEY";
  static String userEmailKey =  "USEREMAILKEY";
  static String userProfileKey = "USERPROFILEKEY";

  final user = FirebaseAuth.instance.currentUser!;

  // NOTE: I think the following code can be optimized to a single function with a switch case
  // WARNING: this code may throw a null safe operator used in null value or something like that
  // Saving data with sharedPreferences
  Future<bool> saveUserId(String? getUserId) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString(userIdKey, getUserId!);
  }
  
  Future<bool> saveUserName(String? getUserName) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
      return preferences.setString(userNameKey, getUserName!);
  }

  Future<bool> saveDisplayName(String? getDisplayName) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString(displayNameKey, getDisplayName!);
  }

  Future<bool> saveUserEmail(String? getUserEmail) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString(userEmailKey, getUserEmail!);
  }

  Future<bool> saveUserProfile(String? getUserProfile) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString(userProfileKey, getUserProfile!);
  }

  // Get data
  Future<String?> getUserId () async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(userIdKey) ?? user.uid; 
  }
  Future<String?> getUserName () async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(userNameKey) ?? user.email!.replaceAll("@gmail.com", ""); 
  }

  Future<String?> getDisplayName () async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(displayNameKey) ?? user.displayName; 
  }

  Future<String?> getUserEmail () async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(userEmailKey) ?? user.email ; 
  }

  Future<String?> getUserProfile () async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(userProfileKey) ?? user.photoURL
     ; 
  }
   
}
