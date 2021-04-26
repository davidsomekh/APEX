Trigger TaskUpdateMobile on Task(before insert, before update){
    Map<Id, List<Task>> whoIds = new Map<Id, List<Task>>{};

    For (Task t : trigger.new)
        If(t.WhoId != null){
            List<Task> tasks = whoIds.get(t.WhoId); //this should be t.WhoId (not task.WhoId)
            If (tasks == null){
            tasks = new List<Task>{};
            whoIds.put(t.WhoId, tasks);
        }
        tasks.add(t);
    }

    For (Lead ld : [Select Id, Name, MobilePhone from lead where Id in :whoIDs.keySet()])
        For(Task t : whoIds.get(ld.id))
            t.Mobile__c = ld.MobilePhone;

    For(Contact con : [Select Id, Name, MobilePhone from Contact where Id in :whoIds.keySet()])
        For(Task t : whoIds.get(con.id))
            t.Mobile__c = con.MobilePhone;

}