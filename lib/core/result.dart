import 'package:flutter/foundation.dart';

import 'exceptions.dart';

/// A type that represents either a success or a failure.
/// 
/// This is a Dart implementation of the Result/Either pattern commonly used
/// in functional programming for explicit error handling without exceptions.
/// 
/// Example usage:
/// ```dart
/// Future<Result<UserProfile>> loadProfile() async {
///   try {
///     final profile = await service.getProfile();
///     return Result.success(profile);
///   } catch (e, st) {
///     return Result.failure(
///       StorageException.readFailure(cause: e, stackTrace: st),
///     );
///   }
/// }
/// 
/// final result = await loadProfile();
/// result.when(
///   success: (profile) => print('Loaded: ${profile.name}'),
///   failure: (error) => print('Error: $error'),
/// );
/// ```
@immutable
sealed class Result<T> {
  const Result();

  /// Creates a successful result with a value.
  const factory Result.success(T value) = Success<T>;

  /// Creates a failure result with an exception.
  const factory Result.failure(AppException exception) = Failure<T>;

  /// Returns true if this is a success result.
  bool get isSuccess => this is Success<T>;

  /// Returns true if this is a failure result.
  bool get isFailure => this is Failure<T>;

  /// Gets the value if this is a success, otherwise returns null.
  T? get valueOrNull {
    return switch (this) {
      Success(value: final v) => v,
      Failure() => null,
    };
  }

  /// Gets the exception if this is a failure, otherwise returns null.
  AppException? get exceptionOrNull {
    return switch (this) {
      Success() => null,
      Failure(exception: final e) => e,
    };
  }

  /// Gets the value if this is a success, otherwise throws the exception.
  T get valueOrThrow {
    return switch (this) {
      Success(value: final v) => v,
      Failure(exception: final e) => throw e,
    };
  }

  /// Gets the value if this is a success, otherwise returns the provided default value.
  T getOrElse(T defaultValue) {
    return switch (this) {
      Success(value: final v) => v,
      Failure() => defaultValue,
    };
  }

  /// Gets the value if this is a success, otherwise computes a default value.
  T getOrElseCompute(T Function(AppException exception) defaultValue) {
    return switch (this) {
      Success(value: final v) => v,
      Failure(exception: final e) => defaultValue(e),
    };
  }

  /// Transforms the success value using the provided function.
  /// 
  /// If this is a failure, returns the failure unchanged.
  Result<R> map<R>(R Function(T value) transform) {
    return switch (this) {
      Success(value: final v) => Result.success(transform(v)),
      Failure(exception: final e) => Result.failure(e),
    };
  }

  /// Transforms the success value using a function that returns a Result.
  /// 
  /// If this is a failure, returns the failure unchanged.
  /// This is useful for chaining operations that can fail.
  Result<R> flatMap<R>(Result<R> Function(T value) transform) {
    return switch (this) {
      Success(value: final v) => transform(v),
      Failure(exception: final e) => Result.failure(e),
    };
  }

  /// Transforms the failure exception using the provided function.
  /// 
  /// If this is a success, returns the success unchanged.
  Result<T> mapError(AppException Function(AppException exception) transform) {
    return switch (this) {
      Success(value: final v) => Result.success(v),
      Failure(exception: final e) => Result.failure(transform(e)),
    };
  }

  /// Executes one of the provided functions based on whether this is a success or failure.
  R when<R>({
    required R Function(T value) success,
    required R Function(AppException exception) failure,
  }) {
    return switch (this) {
      Success(value: final v) => success(v),
      Failure(exception: final e) => failure(e),
    };
  }

  /// Executes one of the provided functions based on whether this is a success or failure.
  /// 
  /// Unlike [when], this method returns void and is used for side effects.
  void whenOrNull({
    void Function(T value)? success,
    void Function(AppException exception)? failure,
  }) {
    switch (this) {
      case Success(value: final v):
        success?.call(v);
      case Failure(exception: final e):
        failure?.call(e);
    }
  }

  /// Executes the provided function if this is a success.
  /// 
  /// Returns this result unchanged.
  Result<T> onSuccess(void Function(T value) action) {
    if (this case Success(value: final v)) {
      action(v);
    }
    return this;
  }

  /// Executes the provided function if this is a failure.
  /// 
  /// Returns this result unchanged.
  Result<T> onFailure(void Function(AppException exception) action) {
    if (this case Failure(exception: final e)) {
      action(e);
    }
    return this;
  }
}

/// Represents a successful result with a value.
final class Success<T> extends Result<T> {
  final T value;

  const Success(this.value);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Success<T> && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'Success($value)';
}

/// Represents a failed result with an exception.
final class Failure<T> extends Result<T> {
  final AppException exception;

  const Failure(this.exception);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Failure<T> && other.exception == exception;
  }

  @override
  int get hashCode => exception.hashCode;

  @override
  String toString() => 'Failure($exception)';
}

/// Extension methods for Future<Result<T>>
extension FutureResultExtension<T> on Future<Result<T>> {
  /// Transforms the success value using the provided async function.
  Future<Result<R>> mapAsync<R>(Future<R> Function(T value) transform) async {
    final result = await this;
    return result.when(
      success: (value) async {
        try {
          final transformed = await transform(value);
          return Result.success(transformed);
        } catch (e, st) {
          if (e is AppException) {
            return Result.failure(e);
          }
          return Result.failure(
            AppException('Unexpected error: $e', cause: e, stackTrace: st),
          );
        }
      },
      failure: (exception) => Result.failure(exception),
    );
  }

  /// Transforms the success value using a function that returns a Future<Result>.
  Future<Result<R>> flatMapAsync<R>(
    Future<Result<R>> Function(T value) transform,
  ) async {
    final result = await this;
    return result.when(
      success: (value) => transform(value),
      failure: (exception) => Result.failure(exception),
    );
  }

  /// Gets the value if this is a success, otherwise returns the provided default value.
  Future<T> getOrElseAsync(T defaultValue) async {
    final result = await this;
    return result.getOrElse(defaultValue);
  }

  /// Gets the value if this is a success, otherwise computes a default value asynchronously.
  Future<T> getOrElseComputeAsync(
    Future<T> Function(AppException exception) defaultValue,
  ) async {
    final result = await this;
    return result.when(
      success: (value) => value,
      failure: (exception) => defaultValue(exception),
    );
  }
}

/// Helper function to wrap a computation in a Result
Result<T> runCatching<T>(T Function() computation) {
  try {
    return Result.success(computation());
  } catch (e, st) {
    if (e is AppException) {
      return Result.failure(e);
    }
    return Result.failure(
      AppException('Unexpected error: $e', cause: e, stackTrace: st),
    );
  }
}

/// Helper function to wrap an async computation in a Result
Future<Result<T>> runCatchingAsync<T>(
  Future<T> Function() computation,
) async {
  try {
    final value = await computation();
    return Result.success(value);
  } catch (e, st) {
    if (e is AppException) {
      return Result.failure(e);
    }
    return Result.failure(
      AppException('Unexpected error: $e', cause: e, stackTrace: st),
    );
  }
}
