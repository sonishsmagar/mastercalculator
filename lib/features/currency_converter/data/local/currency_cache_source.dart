class CurrencyCacheSource {
  final Map<String, dynamic> _cache = {};
  final Map<String, DateTime> _cacheTimestamps = {};

  void cacheRates(String key, dynamic rates,
      {Duration duration = const Duration(hours: 1)}) {
    _cache[key] = rates;
    _cacheTimestamps[key] = DateTime.now().add(duration);
  }

  dynamic getCachedRates(String key) {
    final expiry = _cacheTimestamps[key];
    if (expiry == null || DateTime.now().isAfter(expiry)) {
      _cache.remove(key);
      _cacheTimestamps.remove(key);
      return null;
    }
    return _cache[key];
  }

  void clearCache() {
    _cache.clear();
    _cacheTimestamps.clear();
  }

  void removeFromCache(String key) {
    _cache.remove(key);
    _cacheTimestamps.remove(key);
  }
}
