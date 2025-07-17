public class StringListTest {
    public static String[] generateStringList (Integer I) {
        List<String> stringList = new List<String> ();
        
        for (Integer p = 0; p< I; p = p+1) {
            String sInteger = String.valueOf(p);
            stringList.add('Test ' + sInteger);
        }
        
        
        return stringList;
    }

}