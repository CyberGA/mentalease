class ChatFailure {
  final String message;

  const ChatFailure([this.message = "An error occurred. Please try again"]);

  factory ChatFailure.code({required String code, String? message}) {
    switch (code) {
      default:
        return const ChatFailure();
    }
  }
}
