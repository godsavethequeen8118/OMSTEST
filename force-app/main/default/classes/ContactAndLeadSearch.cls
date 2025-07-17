public class ContactAndLeadSearch {
    public static List<List< sObject>> searchContactsAndLeads (String s) {
        List<List< sObject>> contactLeads = [FIND :s IN ALL FIELDS RETURNING Lead(FirstName,LastName),Contact(FirstName,LastName,Department)]; 
        
        return contactLeads;
    }

}