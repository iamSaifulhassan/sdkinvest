import '../../models/auth/auth_user.dart';

/// Thrown by [AuthRepository] on invalid credentials or a failed sign-up so
/// callers can show a specific message instead of a generic failure.
class AuthException implements Exception {
  const AuthException(this.message);
  final String message;
}

/// Auth contract. [MockAuthRepository] simulates network latency and basic
/// validation with no real backend — swap in an API-backed implementation
/// once one exists; every cubit that depends on this keeps working unchanged.
abstract class AuthRepository {
  Future<AuthUser> signIn({required String email, required String password});

  Future<AuthUser> signUp({
    required String name,
    required String email,
    required String password,
  });
}

class MockAuthRepository implements AuthRepository {
  const MockAuthRepository();

  @override
  Future<AuthUser> signIn({
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 900));
    // No real backend to check credentials against, so any well-formed
    // attempt succeeds — LoginCubit already validates email format and a
    // non-empty password before this is ever called. (This used to reject
    // passwords under 6 characters to demo the failure path, but that meant
    // a plausible real attempt could dead-end on a generic error with no
    // way forward — the wrong trade-off for a demo build.)
    return AuthUser(name: _nameFromEmail(email), email: email);
  }

  @override
  Future<AuthUser> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 900));
    return AuthUser(name: name, email: email);
  }

  String _nameFromEmail(String email) {
    final handle = email.split('@').first;
    if (handle.isEmpty) return 'there';
    return handle[0].toUpperCase() + handle.substring(1);
  }
}
