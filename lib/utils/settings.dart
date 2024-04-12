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
      "buyCoffeeUrl": "https://paypal.me/judahpaul",
      "pinterestUrl": "https://pinterest.com/",
      "facebookUrl": "https://facebook.com/",
      "instagramUrl": "https://instagram.com/",
      "dribbbleUrl": "https://dribbble.com/",
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
  static String get pinterestUrl => AppSettings.settings['pinterestUrl'];
  static set pinterestUrl(String value) =>
      AppSettings.updateSetting('pinterestUrl', value);
  static String get facebookUrl => AppSettings.settings['facebookUrl'];
  static set facebookUrl(String value) =>
      AppSettings.updateSetting('facebookUrl', value);
  static String get instagramUrl => AppSettings.settings['instagramUrl'];
  static set instagramUrl(String value) =>
      AppSettings.updateSetting('instagramUrl', value);
  static String get dribbbleUrl => AppSettings.settings['dribbbleUrl'];
  static set dribbbleUrl(String value) =>
      AppSettings.updateSetting('dribbbleUrl', value);
}
