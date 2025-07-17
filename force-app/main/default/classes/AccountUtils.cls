public class AccountUtils {
    public static List<Account> accountsByState(String state) {
        List<Account> accountList = [SELECT ID, name FROM Account WHERE billingState = :state];
        return accountList;
    }
}