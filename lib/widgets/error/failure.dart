import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  // если false, то сообщение не будет показано на экране
  // костыль, но у меня нет сейчас времени
  final bool seriously;

  const Failure({this.message = '', this.seriously = true});

  @override
  List<Object> get props => [message];
}

class ConnectionFailure extends Failure {
  const ConnectionFailure({required String message}) : super(message: message);
}


class NeedUpdateError extends Failure {
  const NeedUpdateError({required String message}) : super(message: message);
}

class NoAuthError extends Failure {
  const NoAuthError({required String message}) : super(message: message);
}
class NoAuthFailure extends Failure {
  const NoAuthFailure({required String message}) : super(message: message);
}

class ServerFailuer extends Failure {
  const ServerFailuer({required String message, seriously = true})
      : super(message: message, seriously: seriously);
}
