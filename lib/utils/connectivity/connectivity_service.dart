import 'package:connectivity_plus/connectivity_plus.dart';

/// Service to check network connectivity
class ConnectivityService {
  final Connectivity _connectivity;

  ConnectivityService({Connectivity? connectivity})
      : _connectivity = connectivity ?? Connectivity();

  /// Check if device has network connectivity
  Future<bool> hasNetworkConnection() async {
    try {
      final result = await _connectivity.checkConnectivity();
      
      // Check if we have any type of connection (mobile, wifi, ethernet, etc.)
      // ConnectivityResult.none means no connection
      return result.any((connectivityResult) => 
        connectivityResult != ConnectivityResult.none
      );
    } catch (e) {
      // If we can't check connectivity, assume no connection
      return false;
    }
  }

  /// Stream of connectivity changes
  Stream<bool> get onConnectivityChanged {
    return _connectivity.onConnectivityChanged.map((results) {
      return results.any((result) => result != ConnectivityResult.none);
    });
  }

  /// Check for specific connection types
  Future<bool> hasWifiConnection() async {
    try {
      final result = await _connectivity.checkConnectivity();
      return result.contains(ConnectivityResult.wifi);
    } catch (e) {
      return false;
    }
  }

  Future<bool> hasMobileConnection() async {
    try {
      final result = await _connectivity.checkConnectivity();
      return result.contains(ConnectivityResult.mobile);
    } catch (e) {
      return false;
    }
  }
}

