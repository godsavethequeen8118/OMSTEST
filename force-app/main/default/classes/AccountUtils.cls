public class AccountUtils {
    public static List<Account> accountsByState(String state) {
        List<Account> accountList = [SELECT ID FROM Account WHERE billingState = :state];
        return accountList;
    }
}