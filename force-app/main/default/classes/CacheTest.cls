@isTest
class CacheTest {
  @isTest
  static void doTest() {
    RecordGenerator theQuery = RecordGeneratorsImpl.accounts;
    Account theAccount = new Account(Name = 'Test');
    insert theAccount;
    Cache.invalidateCache();
    Cache.cacheQueryRequest(theQuery, new Set<Id>{ theAccount.Id });
    Account[] records = Cache.getQueryResults(theQuery).values();
    Assert.areEqual(1, Limits.getQueries());
    Assert.areEqual(1, records.size());

    Cache.cacheQueryRequest(theQuery, new List<Id>{ theAccount.Id });
    records = Cache.getQueryResults(theQuery).values();
    Assert.areEqual(1, Limits.getQueries());

    Cache.setAccessLevel(AccessLevel.SYSTEM_MODE);
    records = Cache.getQueryResults(theQuery).values();
    Assert.areEqual(0, records.size());

    Cache.invalidateQueryCache(theQuery);
    Cache.invalidateRecordCache(theQuery);
    Cache.addQueryResults(theQuery, new List<Account>{ theAccount });
    records = Cache.getQueryResults(theQuery).values();
    Assert.areEqual(1, records.size());

    Assert.areEqual(1, Limits.getQueries());
    Cache.removeIdsFromResults(new List<Id>{ theAccount.Id });
    records = Cache.getQueryResults(theQuery).values();
    Assert.areEqual(0, records.size());

    Cache.invalidateCache();
  }
  class FakeAccountGenerator extends RecordGenerator {
    public override sObject[] getRecords(Set<Id> ids, AccessLevel securityLevel) {
        return new Account[0];
    }
    public override Map<Id, sObject> getConcreteMap() {
        return new Map<Id, Account>();
    }
  }
  @isTest
  static void testExamples() {
    // NOPMD
    RecordGenerator theQuery = new FakeAccountGenerator();
    // We can fake records by warming the cache
    // You can't use invalid Ids to link records together, though.
    Account theAccount = new Account(Id = '001000000000001AAA', Name = 'Test'); // NOPMD
    Cache.addQueryResults(theQuery, new List<Account>{ theAccount });
    Account[] results = Cache.getQueryResults(theQuery).values();
    Assert.areEqual(1, results.size());
    Assert.areEqual(0, Limits.getQueries());

    // We can also fake queries at the cost of DML (see AccountTrigger.trigger)
    theAccount = new Account(Name = 'Test');
    insert theAccount;
    RecordGenerator theSelectAllQuery = RecordGeneratorsImpl.accounts;
    Cache.cacheQueryRequest(theSelectAllQuery, new Set<Id>{ theAccount.Id });
    results = Cache.getQueryResults(theSelectAllQuery).values();
    Assert.areEqual(0, Limits.getQueries());
    Assert.areEqual(theAccount.Id, results[0].Id);
  }
}
