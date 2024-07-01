class OpdClientInitPreconditionError implements Exception{
  final String cause;

  OpdClientInitPreconditionError(this.cause);

  @override
  String toString() => 'OpdClient Init Precondition Error: $cause';
}

class OpdClientInitException implements Exception{
  final Object e;

  OpdClientInitException(this.e);

  @override
  String toString() => e.toString();
}

