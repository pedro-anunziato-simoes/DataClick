abstract class RequestState<T> {
  const RequestState();
}

class InitialState<T> extends RequestState<T> {
  const InitialState();
}

class LoadingState<T> extends RequestState<T> {
  const LoadingState();
}

class SuccessState<T> extends RequestState<T> {
  final T data;
  const SuccessState(this.data);
}

class ErrorState<T> extends RequestState<T> {
  final String message;
  const ErrorState(this.message);
}