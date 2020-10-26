public without sharing class baf_ObjectHelper {
    public static String ConvertToNumberForSoql(Object value) {
        return String.valueOf(value);
    }

    public static String ConvertToDateForSoql(Object value) {
        if (value == null) { return null; }
        if (!(value instanceof Date)) { return null; }
        Date dd = (Date) value;
        String fd = String.valueOf(dd.year());
        fd += '-' + baf_StringHelper.PadNumeric(dd.month(), 2);
        fd += '-' + baf_StringHelper.PadNumeric(dd.day(), 2);
        return fd;
    }

    public static String ConvertToDateTimeForSoql(Object value) {
        if (!(value instanceof Date)) { return null; }
        DateTime dt = (DateTime) value;
        return (dt == null ? null : dt.formatGmt('yyyy-MM-dd HH:mm:ss').replace(' ','T')+'Z');
    }

    public static String ConvertToStringForSoql(Object value) {
        return '\'' + String.valueOf(value) + '\'';
    }

    public static String ConvertToBooleanForSoql(Object value) {
        if (value == null) { return null; }
        if (!(value instanceof Boolean)) { return null; }
        Boolean bb = (Boolean) value;
        return bb ? 'true' : 'false';
    }
}