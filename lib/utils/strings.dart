import 'package:shared_preferences/shared_preferences.dart';

class AppStrings {
  static late SharedPreferences _prefs;

  // Customization
  static String appTitle = "Artfolio";
  static String homePageTitle = "Artfolio Showcase";

  // User settings
  static String name = "Judah Paul";
  static String username = "admin";
  static String password = "admin123";

  // Disqus comments
  static String disqusShortname = "artfolio-1";
  static String disqusUrl = "https://github.com/judahpaul16/artfolio";

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();

    appTitle = _prefs.getString('appTitle') ?? appTitle;
    homePageTitle = _prefs.getString('homePageTitle') ?? homePageTitle;
    name = _prefs.getString('str_name') ?? name;
    username = _prefs.getString('str_username') ?? username;
    password = _prefs.getString('str_password') ?? password;
    disqusShortname = _prefs.getString('disqusShortname') ?? disqusShortname;
    disqusUrl = _prefs.getString('disqusUrl') ?? disqusUrl;
  }

  static void save() {
    _prefs.setString('appTitle', appTitle);
    _prefs.setString('homePageTitle', homePageTitle);
    _prefs.setString('str_name', name);
    _prefs.setString('str_username', username);
    _prefs.setString('str_password', password);
    _prefs.setString('disqusShortname', disqusShortname);
    _prefs.setString('disqusUrl', disqusUrl);
  }
}
