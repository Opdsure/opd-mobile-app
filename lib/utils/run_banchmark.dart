import 'logs/logs.dart';

/// Calculates some benchmarks for this function. Give it a [name] and a [func]
/// to call and it will calculate the needed milliseconds. Give it an optional
/// [itemCount] to let it also calculate the needed milliseconds per item.
Future<T> runBenchmarked<T>(
    String name,
    Future<T> Function() func, [
      int? itemCount,
    ]) async {
  if (Logs().level.index < Level.debug.index) {
    return func();
  }
  final start = DateTime.now();
  final result = await func();
  final milliseconds =
      DateTime.now().millisecondsSinceEpoch - start.millisecondsSinceEpoch;
  var message = 'Benchmark: $name -> $milliseconds ms';
  if (itemCount != null) {
    message +=
    ' ($itemCount items, ${itemCount > 0 ? milliseconds / itemCount : milliseconds} ms/item)';
  }
  Logs().d(message);
  return result;
}