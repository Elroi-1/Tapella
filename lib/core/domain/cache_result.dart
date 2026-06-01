class CacheResult<T> {
  final T data;
  final bool isStale;

  const CacheResult({required this.data, this.isStale = false});
}
