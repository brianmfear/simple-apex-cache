public class RecordGeneratorsImpl {
  public static RecordGenerator accounts = new AccountRecordGenerator();

  public class AccountRecordGenerator extends RecordGenerator {
    AccountRecordGenerator() {
    }
    public override sObject[] getRecords(
      Set<Id> recordIds,
      AccessLevel securityLevel
    ) {
      return Database.queryWithBinds(
        'SELECT Id FROM Account WHERE Id IN :recordIds',
        new Map<String, Object>{ 'recordIds' => recordIds },
        securityLevel
      );
    }
    public override Map<Id, sObject> getConcreteMap() {
      return new Map<Id, Account>();
    }
  }
}
