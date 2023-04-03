class AuthFailure {
  final String message;

  const AuthFailure([this.message = "An error occurred. Please try again"]);

  factory AuthFailure.code({required String code, String? message}) {
    switch (code) {
      case 'weak-password':
        return const AuthFailure('Please enter a stronger password');
      case 'wrong-password':
        return const AuthFailure('Email or password incorrect');
      case 'invalid-email':
        return const AuthFailure('Please enter a valid email address');
      case 'email-already-in-use':
        return const AuthFailure('An account already exists for this email');
      case 'operation-not-allowed':
        return const AuthFailure('Operation failed. Please contact support.');
      case 'user-not-found':
        return AuthFailure(message ?? 'No account exists for this email');
      case 'user-disabled':
        return const AuthFailure('This user has been disabled. Please contact support for help');
      case 'username-already-exits':
        return const AuthFailure('This username has already been taken');
      case 'incorrect-user-role':
        return const AuthFailure('Email or password incorrect. Ensure you choose the correct account type');
      default:
        return const AuthFailure();
    }
  }
}
