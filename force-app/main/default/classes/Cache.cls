public class Cache {
  static AccessLevel securityLevel = AccessLevel.USER_MODE;

  static Map<RecordGenerator, Map<Id, sObject>> recordCache = new Map<RecordGenerator, Map<Id, SObject>>();
  static Map<RecordGenerator, Set<Id>> queryCache = new Map<RecordGenerator, Set<Id>>();

  public static Map<String, RecordGenerator> generators = new Map<String, RecordGenerator>();

  public static void cacheQueryRequest(
    RecordGenerator generator,
    Id[] idValues
  ) {
    cacheQueryRequest(generator, new Set<Id>(idValues));
  }
  public static void cacheQueryRequest(
    RecordGenerator generator,
    Set<Id> idValues
  ) {
    Set<Id> ids = queryCache.get(generator);
    if (ids == null) {
      queryCache.put(generator, ids = new Set<Id>());
    }
    ids.addAll(idValues);
  }

  public static void invalidateRecordCache(RecordGenerator generator) {
    recordCache.remove(generator);
  }

  public static void invalidateQueryCache(RecordGenerator generator) {
    queryCache.remove(generator);
  }

  public static void invalidateCache() {
    recordCache.clear();
    queryCache.clear();
  }

  public static void flushCache() {
    for (RecordGenerator generator : queryCache.keySet()) {
      Map<Id, sObject> temp = recordCache.get(generator);
      if (temp == null) {
        recordCache.put(generator, temp = generator.getConcreteMap());
      }
      Set<Id> requestedIds = queryCache.get(generator).clone();
      requestedIds.removeAll(temp.keySet());
      if (requestedIds.isEmpty()) {
        return;
      }
      temp.putAll(generator.getRecords(requestedIds, securityLevel));
    }
  }
  public static void setAccessLevel(AccessLevel theAccessLevel) {
    if (theAccessLevel != securityLevel) {
      invalidateCache();
      securityLevel = theAccessLevel;
    }
  }
  public static Map<Id, sObject> getQueryResults(RecordGenerator generator) {
    flushCache();
    Map<Id, sObject> results = recordCache.get(generator);
    if (results == null) {
      recordCache.put(generator, results = generator.getConcreteMap());
    }
    return results;
  }
  public static void addQueryResults(
    RecordGenerator generator,
    sObject[] records
  ) {
    Map<Id, sObject> temp = recordCache.get(generator);
    if (temp == null) {
      recordCache.put(generator, temp = generator.getConcreteMap());
    }
    temp.putAll(records);
  }
  public static void removeIdsFromResults(Id[] recordIds) {
    removeIdsFromResults(new Set<Id>(recordIds));
  }
  public static void removeIdsFromResults(Set<Id> recordIds) {
    for (Map<Id, sObject> cachedIds : recordCache.values()) {
      cachedIds.keySet().removeAll(recordIds);
    }
  }
}
