public with sharing class AccountHandler {
    public static void CreateNewOpportunity(List<Account> accts) {
        for (Account a : accts) {
            Opportunity opp = new Opportunity();
            opp.Name = a.Name + ' Opportunity';
            opp.AccountId = a.Id;
            opp.StageName = 'Prospecting';
            opp.CloseDate = System.Today().addMonths(1);
            insert opp;
        }
    }
    
    public static Account insertNewAccount (String accountName) {
        try {
            Account acct = new Account (Name=accountName, AccountNumber='12345699');
            insert acct;
            
            return acct;
            
        } catch (DmlException e) {
            return null;
        }
    }
}