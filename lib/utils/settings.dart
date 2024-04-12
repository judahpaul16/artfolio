class AppSettings {
  static Map<String, dynamic> settings = {};

  static Future<void> loadSettings() async {
    settings = {
      "appTitle": "Artfolio",
      "homePageTitle": "Artfolio Showcase",
      "fullname": "Judah Paul",
      "username": "admin",
      "password": "admin123",
      "disqusShortname": "artfolio-1",
      "disqusUrl": "https://github.com/judahpaul16/artfolio",
      "buyCoffeeUrl": "https://paypal.me/judahpaul"
    };
  }

  static void updateSetting(String key, dynamic value) {
    settings[key] = value;
  }
}

class AppStrings {
  static Future<void> init() async {
    await AppSettings.loadSettings();
  }

  static String get appTitle => AppSettings.settings['appTitle'];
  static set appTitle(String value) =>
      AppSettings.updateSetting('appTitle', value);
  static String get homePageTitle => AppSettings.settings['homePageTitle'];
  static set homePageTitle(String value) =>
      AppSettings.updateSetting('homePageTitle', value);
  static String get fullname => AppSettings.settings['fullname'];
  static set fullname(String value) =>
      AppSettings.updateSetting('fullname', value);
  static String get username => AppSettings.settings['username'];
  static set username(String value) =>
      AppSettings.updateSetting('username', value);
  static String get password => AppSettings.settings['password'];
  static set password(String value) =>
      AppSettings.updateSetting('password', value);
  static String get disqusShortname => AppSettings.settings['disqusShortname'];
  static set disqusShortname(String value) =>
      AppSettings.updateSetting('disqusShortname', value);
  static String get disqusUrl => AppSettings.settings['disqusUrl'];
  static set disqusUrl(String value) =>
      AppSettings.updateSetting('disqusUrl', value);
  static String get buyCoffeeUrl => AppSettings.settings['buyCoffeeUrl'];
  static set buyCoffeeUrl(String value) =>
      AppSettings.updateSetting('buyCoffeeUrl', value);
}
