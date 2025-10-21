/// Custom exception classes for the SmokeTracker application.
/// 
/// These exceptions provide specific error types for different failure scenarios,
/// making error handling more precise and informative.
library exceptions;

/// Base exception class for all application-specific exceptions.
abstract class AppException implements Exception {
  /// Human-readable error message
  final String message;

  /// Optional underlying cause of the exception
  final Object? cause;

  /// Optional stack trace
  final StackTrace? stackTrace;

  const AppException(
    this.message, {
    this.cause,
    this.stackTrace,
  });

  @override
  String toString() {
    final buffer = StringBuffer('$runtimeType: $message');
    if (cause != null) {
      buffer.write('\nCause: $cause');
    }
    if (stackTrace != null) {
      buffer.write('\nStack trace:\n$stackTrace');
    }
    return buffer.toString();
  }
}

/// Exception thrown when data storage operations fail.
class StorageException extends AppException {
  const StorageException(
    super.message, {
    super.cause,
    super.stackTrace,
  });

  /// Creates a StorageException for read failures
  const StorageException.readFailure({
    String? key,
    Object? cause,
    StackTrace? stackTrace,
  }) : super(
          'Failed to read data${key != null ? ' for key: $key' : ''}',
          cause: cause,
          stackTrace: stackTrace,
        );

  /// Creates a StorageException for write failures
  const StorageException.writeFailure({
    String? key,
    Object? cause,
    StackTrace? stackTrace,
  }) : super(
          'Failed to write data${key != null ? ' for key: $key' : ''}',
          cause: cause,
          stackTrace: stackTrace,
        );

  /// Creates a StorageException for delete failures
  const StorageException.deleteFailure({
    String? key,
    Object? cause,
    StackTrace? stackTrace,
  }) : super(
          'Failed to delete data${key != null ? ' for key: $key' : ''}',
          cause: cause,
          stackTrace: stackTrace,
        );
}

/// Exception thrown when JSON parsing fails.
class ParseException extends AppException {
  /// The type that was being parsed
  final Type? targetType;

  const ParseException(
    super.message, {
    this.targetType,
    super.cause,
    super.stackTrace,
  });

  /// Creates a ParseException for JSON parsing failures
  const ParseException.jsonParse({
    Type? targetType,
    Object? cause,
    StackTrace? stackTrace,
  }) : this(
          'Failed to parse JSON${targetType != null ? ' to type: $targetType' : ''}',
          targetType: targetType,
          cause: cause,
          stackTrace: stackTrace,
        );

  @override
  String toString() {
    final buffer = StringBuffer('ParseException: $message');
    if (targetType != null) {
      buffer.write(' (target type: $targetType)');
    }
    if (cause != null) {
      buffer.write('\nCause: $cause');
    }
    return buffer.toString();
  }
}

/// Exception thrown when data validation fails.
class ValidationException extends AppException {
  /// The field that failed validation
  final String? field;

  const ValidationException(
    super.message, {
    this.field,
    super.cause,
    super.stackTrace,
  });

  /// Creates a ValidationException for required field failures
  const ValidationException.requiredField(String field)
      : this(
          'Required field is missing: $field',
          field: field,
        );

  /// Creates a ValidationException for invalid format failures
  const ValidationException.invalidFormat(
    String field, {
    String? expectedFormat,
  }) : this(
          'Invalid format for field: $field${expectedFormat != null ? ' (expected: $expectedFormat)' : ''}',
          field: field,
        );

  /// Creates a ValidationException for out of range values
  const ValidationException.outOfRange(
    String field, {
    num? min,
    num? max,
    num? actual,
  }) : this(
          'Value out of range for field: $field${min != null && max != null ? ' (expected: $min-$max, got: $actual)' : ''}',
          field: field,
        );

  @override
  String toString() {
    final buffer = StringBuffer('ValidationException: $message');
    if (field != null) {
      buffer.write(' (field: $field)');
    }
    return buffer.toString();
  }
}

/// Exception thrown when service initialization fails.
class InitializationException extends AppException {
  /// The service that failed to initialize
  final String? service;

  const InitializationException(
    super.message, {
    this.service,
    super.cause,
    super.stackTrace,
  });

  /// Creates an InitializationException for service initialization failures
  const InitializationException.serviceInit(
    String service, {
    Object? cause,
    StackTrace? stackTrace,
  }) : this(
          'Failed to initialize service: $service',
          service: service,
          cause: cause,
          stackTrace: stackTrace,
        );
}

/// Exception thrown when a requested resource is not found.
class NotFoundException extends AppException {
  /// The type of resource that was not found
  final String? resourceType;

  /// The identifier of the resource that was not found
  final dynamic resourceId;

  const NotFoundException(
    super.message, {
    this.resourceType,
    this.resourceId,
    super.cause,
    super.stackTrace,
  });

  /// Creates a NotFoundException for a specific resource
  const NotFoundException.resource(
    String resourceType,
    dynamic resourceId,
  ) : this(
          'Resource not found: $resourceType with ID: $resourceId',
          resourceType: resourceType,
          resourceId: resourceId,
        );

  @override
  String toString() {
    final buffer = StringBuffer('NotFoundException: $message');
    if (resourceType != null && resourceId != null) {
      buffer.write(' ($resourceType: $resourceId)');
    }
    return buffer.toString();
  }
}

/// Exception thrown when an operation is attempted on uninitialized state.
class StateException extends AppException {
  const StateException(
    super.message, {
    super.cause,
    super.stackTrace,
  });

  /// Creates a StateException for uninitialized state
  const StateException.uninitialized(String service)
      : super('$service is not initialized. Call init() first.');

  /// Creates a StateException for invalid state
  const StateException.invalidState(String reason)
      : super('Invalid state: $reason');
}

/// Exception thrown when network-related operations fail.
class NetworkException extends AppException {
  /// HTTP status code if applicable
  final int? statusCode;

  const NetworkException(
    super.message, {
    this.statusCode,
    super.cause,
    super.stackTrace,
  });

  /// Creates a NetworkException for connection failures
  const NetworkException.connectionFailure({
    Object? cause,
    StackTrace? stackTrace,
  }) : this(
          'Network connection failed',
          cause: cause,
          stackTrace: stackTrace,
        );

  /// Creates a NetworkException for timeout
  const NetworkException.timeout()
      : this('Network request timed out');

  @override
  String toString() {
    final buffer = StringBuffer('NetworkException: $message');
    if (statusCode != null) {
      buffer.write(' (status code: $statusCode)');
    }
    return buffer.toString();
  }
}

/// Exception thrown when file operations fail.
class FileException extends AppException {
  /// The file path that caused the exception
  final String? filePath;

  const FileException(
    super.message, {
    this.filePath,
    super.cause,
    super.stackTrace,
  });

  /// Creates a FileException for read failures
  const FileException.readFailure(
    String filePath, {
    Object? cause,
    StackTrace? stackTrace,
  }) : this(
          'Failed to read file: $filePath',
          filePath: filePath,
          cause: cause,
          stackTrace: stackTrace,
        );

  /// Creates a FileException for write failures
  const FileException.writeFailure(
    String filePath, {
    Object? cause,
    StackTrace? stackTrace,
  }) : this(
          'Failed to write file: $filePath',
          filePath: filePath,
          cause: cause,
          stackTrace: stackTrace,
        );

  /// Creates a FileException for file not found
  const FileException.notFound(String filePath)
      : this(
          'File not found: $filePath',
          filePath: filePath,
        );

  @override
  String toString() {
    final buffer = StringBuffer('FileException: $message');
    if (filePath != null) {
      buffer.write(' (file: $filePath)');
    }
    return buffer.toString();
  }
}
