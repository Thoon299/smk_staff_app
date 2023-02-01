import 'dart:io';

enum Flavor {
  DEVELOPMENT,
  STAGING,
  RELEASE,
}

class Config {
  static Flavor appFlavor = Flavor.RELEASE;

  static String get apiRoot {
    switch (appFlavor) {
      case Flavor.RELEASE:
        return 'http://something';
      case Flavor.STAGING:
        return 'http://something';
      case Flavor.DEVELOPMENT:
        return 'http://something';
      default:
        return 'http://something';
    }
  }

  static String get apiKey {
    switch (appFlavor) {
      case Flavor.RELEASE:
        return 'LSDF33SOMETHING';
      case Flavor.STAGING:
        return 'LSDF33SOMETHING';
      case Flavor.DEVELOPMENT:
        return 'LSDF33SOMETHING';
      default:
        return 'LSDF33SOMETHING';
    }
  }

  static String get envName {
    switch (Config.appFlavor) {
      case Flavor.RELEASE:
        return "";
      case Flavor.STAGING:
        return "(Staging)";
      case Flavor.DEVELOPMENT:
        return "(Dev)";
      default:
        return "(Dev)";
    }
  }

  static String get environment {
    switch (Config.appFlavor) {
      case Flavor.RELEASE:
        return "production";
      case Flavor.STAGING:
        return "staging";
      case Flavor.DEVELOPMENT:
        return "development";
      default:
        return "development";
    }
  }

  static String get version {
    String androidVersion = "Version 1.0.0";
    String iosVersion = "Version 1.0.0";

    if (Platform.isAndroid) {
      switch (Config.appFlavor) {
        case Flavor.RELEASE:
          return "$androidVersion";
        case Flavor.STAGING:
          return "$androidVersion (staging)";
        case Flavor.DEVELOPMENT:
          return "$androidVersion (dev)";
        default:
          return "$androidVersion (dev)";
      }
    } else {
      switch (Config.appFlavor) {
        case Flavor.RELEASE:
          return "$iosVersion";
        case Flavor.STAGING:
          return "$iosVersion (staging)";
        case Flavor.DEVELOPMENT:
          return "$iosVersion (dev)";
        default:
          return "$iosVersion (dev)";
      }
    }
  }
}
