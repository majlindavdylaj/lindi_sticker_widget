import 'dart:async';

/// A class that manages a stream of values, allowing updates and providing access to the current value.
class IndexStream<T> {
  // Private StreamController used to manage and broadcast stream events.
  final StreamController<T> _stream = StreamController<T>.broadcast();

  // The sink of the StreamController, used to add new values to the stream.
  Sink<T> get _input => _stream.sink;

  // The stream provided by the StreamController, which other parts of the code can listen to.
  Stream<T> get stream => _stream.stream;

  // The current value stored in the IndexStream.
  T? _currentValue;

  // Public getter to access the current value.
  T? get current => _currentValue;

  /// Updates the current value and adds it to the stream.
  ///
  /// [value] is the new value to be set and broadcasted.
  void update(T value) {
    _currentValue = value; // Store the new value.
    _input.add(value); // Add the new value to the stream.
  }

  /// Closes the StreamController and cleans up resources.
  ///
  /// After calling this method, no more events can be added or listened to.
  void close() {
    _stream.close(); // Close the stream to release resources.
  }
}
