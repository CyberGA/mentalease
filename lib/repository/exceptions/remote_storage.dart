class RemoteStorageFailure {
  final String message;

  const RemoteStorageFailure([this.message = "An error occurred. Please try again"]);

  factory RemoteStorageFailure.code({required String code, String? message}) {
    switch (code) {
      case 'ALREADY_EXISTS':
        return const RemoteStorageFailure('Already existing');
      case 'UNAUTHENTICATED':
        return const RemoteStorageFailure('You are not authenticated');
      default:
        return const RemoteStorageFailure();
    }
  }
}
