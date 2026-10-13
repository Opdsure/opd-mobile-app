class OpdClientInitPreconditionError implements Exception {
  final String cause;

  OpdClientInitPreconditionError(this.cause);

  @override
  String toString() => 'OpdClient Init Precondition Error: $cause';
}

class OpdClientInitException implements Exception {
  final Object e;

  OpdClientInitException(this.e);

  @override
  String toString() => e.toString();
}

/// Thrown when the server rejects the stored auth token (HTTP 401/403).
/// Signals that the session is invalid and the user must log in again.
/// Any other failure (404, timeout, no network, 5xx) must NOT throw this, so
/// the persisted session is preserved across transient and non-auth errors.
class OpdUnauthorizedException implements Exception {
  final int statusCode;

  OpdUnauthorizedException(this.statusCode);

  @override
  String toString() => 'OpdUnauthorizedException: HTTP $statusCode';
}
