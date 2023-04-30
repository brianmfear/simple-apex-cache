# simple-apex-cache

This is a demo of using caching in Apex to store data that is frequently queried in an efficient manner. Please see [`CacheTest`](/force-app/main/default/classes/CacheTest.cls) for examples of using the cache.

An abstraction for retrieving data was chosen so that it would be possible to use a QueryBuilder type of implementation, which is not demonstrated here. A singleton design is recommended for the generators, as each new generator is distinct from the others.

Note that there's nothing stopping a developer from querying child records by the parent field, as this can be built as a type of generator, though it would probably more efficient to query the child records as a sub-query instead.

This is meant to be an efficient example, so it does not include excessive error handling.

## API

```
Cache.cacheQueryRequest(generator, recordIds)
```

Prepare a new request and coalesce record Id values.

```
Cache.invalidateRecordCache(generator)
```

Removes records associated with the generator.

```
Cache.invalidateQueryCache(generator)
```

Removes pending queries from the cache.

```
Cache.invalidateCache()
```

Clears all cache entries.

```
Cache.flushCache()
```

Identify records that are not in the cache and load them.

```
Cache.setAccessLevel(AccessLevel)
```

Changes the AccessLevel between USER_MODE and SYSTEM_MODE. If the security model changes, the cache is invalidated.

```
Cache.getQueryResults(generator)
```

Returns all records associated with the generator. Note that the cache will first be flushed before the results are returned.

```
Cache.addQueryResults(generator, records)
```

Adds records to the cache without a query. This can be used for unit tests to fake records, or to save SOQL in a trigger context; see [`AccountTrigger`](/force-app/main/default/triggers/AccountTrigger.trigger) for an example.

```
Cache.removeIdsFromResults(recordIds)
```

Removes specific records from the cache.
