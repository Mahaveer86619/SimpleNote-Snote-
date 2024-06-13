abstract class DataState<T> {
  final T? data;
  final String? error;
  final int? statusCode;

  const DataState({
    this.data,
    this.error,
    this.statusCode,
  });
}

class DataSuccess<T> extends DataState<T> {
  const DataSuccess(T data) : super(data: data);
}

class DataFailure<T> extends DataState<T> {
  const DataFailure(String error, int code) : super(error: error, statusCode: code);
}
