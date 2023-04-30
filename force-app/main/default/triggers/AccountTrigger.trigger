trigger AccountTrigger on Account(after insert, after update) {
  Cache.addQueryResults(RecordGeneratorsImpl.accounts, Trigger.new.deepClone(true));
}
