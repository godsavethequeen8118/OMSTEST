trigger ClosedOpportunityTrigger on Opportunity (after insert, after update) {
    list <Task> tasks = new list<Task>();
    for (Opportunity  opp : [SELECT Id, StageName FROM Opportunity  WHERE (Id in :Trigger.new AND StageName = 'Closed Won')]) {
        tasks.add(new Task(Subject = 'Follow Up Test Task', WhatId = opp.Id ) );
    }
    
    if (tasks.size() > 0) {
        insert tasks;
    }

}