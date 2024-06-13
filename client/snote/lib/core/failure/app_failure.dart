class Appfailure {
  final String message;
  final int statusCode;
  Appfailure([this.message = 'Sorry, something went wrong', this.statusCode = -1]);

  @override
  String toString() => 'AppFailure: $message';
}