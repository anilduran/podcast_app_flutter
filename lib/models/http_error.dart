
class HttpError extends Error {

  final int statusCode;
  final String message;

  HttpError({
    required this.statusCode,
    required this.message
  }); 

  @override
  String toString() {
    return message;
  }

}