import 'dart:async';

/// Possible authentication statuses
enum AuthStatus { unknown, authenticated, unauthenticated }

/// A simple authentication repository that simulates login and logout
class AuthRepository {
  final _controller = StreamController<AuthStatus>();

  /// Stream of authentication status changes
  Stream<AuthStatus> get status async* {
    await Future<void>.delayed(const Duration(seconds: 1));
    yield AuthStatus.unauthenticated;
    yield* _controller.stream;
  }

  /// Simulates a login process
  Future<void> logIn({
    required String username,
    required String password,
  }) async {
    //TODO implement actual authentication logic
    await Future.delayed(
      const Duration(milliseconds: 300),
          () => _controller.add(AuthStatus.authenticated),
    );
  }

  /// Simulates a logout process
  void logOut() {
    _controller.add(AuthStatus.unauthenticated);
  }

  /// Closes the stream controller
  void dispose() => _controller.close();
}