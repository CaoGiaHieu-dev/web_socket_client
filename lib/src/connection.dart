import 'dart:async';
import 'dart:developer';

import 'package:web_socket_client/web_socket_client.dart';

/// An object which contains information regarding the
/// current WebSocket connection.
abstract class Connection extends Stream<ConnectionState> {
  /// The current state of the WebSocket connection.
  ConnectionState get state;
}

/// {@template connection_controller}
/// A WebSocket connection controller.
/// {@endtemplate}
class ConnectionController extends Connection {
  /// {@macro connection_controller}
  ConnectionController()
      : _state = const Connecting(),
        _controller = StreamController<ConnectionState>.broadcast();

  ConnectionState _state;
  final StreamController<ConnectionState> _controller;

  @override
  ConnectionState get state => _state;

  @override
  StreamSubscription<ConnectionState> listen(
    void Function(ConnectionState event)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    return _stream.distinct().listen(
          onData,
          onError: onError,
          onDone: onDone,
          cancelOnError: cancelOnError,
        );
  }

  Stream<ConnectionState> get _stream async* {
    try {
      yield _state;
      yield* _controller.stream;
    } catch (e) {
      log(e.toString());
    }
  }

  /// Notifies listeners of a new connection [state].
  void add(ConnectionState state) {
    try {
      _state = state;
      _controller.add(state);
    } catch (e) {
      log(e.toString());
    }
  }

  /// Closes the controller's stream.
  void close() {
    try {
      _controller.close();
    } catch (e) {
      log(e.toString());
    }
  }
}
