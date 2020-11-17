public without sharing class baf_StringHelper {
    public static String ParamFor(Schema.SObjectField field) {
        String key = baf_SchemaHelper.GetDescribe(field).getName();
        return key.substring(0,1).toLowerCase() + key.substring(1);
    }

    /**
     * Pads a number with leading 0's
     * @param  numberToPad    Integer
     * @param  numberOfZeroes Integer
     * @return      String
     */
    public static String PadNumeric(Integer numberToPad, Integer numberOfZeroes) {
        if (numberToPad == null) { return ''; }
        if (numberOfZeroes == null || numberOfZeroes <= 0) { return ''; }
        String target = String.valueOf(numberToPad);
        Integer num = numberOfZeroes = target.length();
        if (num == null || num < 1) { return target; }
        return target.leftPad(num, '0');
    }

    /**
     * Finds the character at a specific index in a string
     * @param   source  String  The text to search
     * @param   index   Integer The position to retrieve
     * @return      The resulting character
     */
    public static String CharAt(String source, Integer index) {
        if (source == null || String.isBlank(source)
                || index == null || index <= 0
                || index >= source.length()) { return null; }
        return source.subString(index, index+1);
    }

    /**
     * Determines if a string of text is within another string of text
     * @param   source  String  The text to search inside of
     * @param   target  String  The text to search for
     * @return      True/False, whether the string is matched
     */
    public static Boolean Contains(String source, String target) {
        if (source == null || String.isBlank(source)) { return null; }
        return source.indexOf(target) != -1;
    }

    /**
     * Returns the right i positions of the string.
     * @param   s   String  The string to grab the right side of
     * @param   i   Integer The number of characters from the right side to grab and return
     * @return      String
     */
    public static String Right(String s, Integer i) {
        return (s == null || s == '' || i <=0 ) ? '' : (i >= s.length()) ? s : s.subString(s.length() - i, s.length());
    }

    /**
     * Selects a random string from a list of strings
     * @param   listOfStrings   List<String>
     * @return      String
     */
    public static String SelectRandom(List<String> listOfStrings) {
        if (listOfStrings == null || listOfStrings.isEmpty()) { return ''; }
        Integer listSize = listOfStrings.size() - 1;
        Integer rando = Integer.valueof((Math.random() * listSize));
        return listOfStrings[rando];
    }

    /**
     * Generates a random alphanumeric string of given length
     * @param len
     * @return String
     */
    public static String GenerateRandomString(Integer len) {
        final String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz';
        String randStr = '';
        while (randStr.length() < len) {
            Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
            randStr += chars.substring(idx, idx+1);
        }
        return randStr;
    }
}