enum Flavor {
  development,
  production;
}

extension FlavorExtension on Flavor {
  bool get isDevelopment => this == .development;
  bool get isProduction => this == .production;
}

class FlavorConfig {
  static late Flavor appFlavor;

  static String get title {
    switch (appFlavor) {
      case .development:
        return 'Jampa Dev';
      case .production:
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
        appFlavor = .development;
        break;
      case 'production':
        appFlavor = .production;
        break;
      default:
        appFlavor = .development;
    }
  }
}