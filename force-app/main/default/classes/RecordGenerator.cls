public abstract class RecordGenerator {
  public abstract sObject[] getRecords(
    Set<Id> recordIds,
    AccessLevel securityLevel
  );
  public abstract Map<Id, sObject> getConcreteMap();

  static Integer hashCodeCounter = 1;
  Integer myHashCode = hashCodeCounter++;
  // Can be overridden by implementations
  public virtual Integer hashCode() {
    return myHashCode;
  }
  // Can be overridden by implementations
  public virtual Boolean equals(Object other) {
    return this === other;
  }
}
