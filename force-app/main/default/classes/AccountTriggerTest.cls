@isTest

public class AccountTriggerTest {
    @isTest static void TestCreate200Records() {
        // Test Setup data
        // Create 200 new Accounts
        List<Account> accts = new List<Account>();
        for(Integer i=0; i < 200; i++) {
            Account acct = new Account(Name='Rev '+i , BillingState='CA');
            accts.add(acct);
        }
        // Perform Test
        Test.startTest();
        insert accts;
        Test.stopTest();
        List<Account> verifyAccts = [SELECT ShippingState FROM Account where BillingState='CA'];
        
        for (Account a : verifyAccts) {
            
            System.assertEquals('CA', a.ShippingState);
           
        }
    }
}