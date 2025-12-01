enum Flavor {
  development,
  production;
}

class FlavorConfig {
  static late Flavor appFlavor;

  static String get title {
    switch (appFlavor) {
      case Flavor.development:
        return 'Jampa Dev';
      case Flavor.production:
        return 'Jampa';
    }
  }

  // static String get apiBaseUrl {
  //   switch (appFlavor) {
  //     case Flavor.development:
  //       return 'https://api-dev.example.com';
  //     case Flavor.production:
  //       return 'https://api.example.com';
  //   }
  // }

  static void initialize({required String flavor}) {
    switch (flavor) {
      case 'development':
        appFlavor = Flavor.development;
        break;
      case 'production':
        appFlavor = Flavor.production;
        break;
      default:
        appFlavor = Flavor.development;
    }
  }
}