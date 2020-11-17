/**
 * Utility methods for construction of SOQL dynamically
 */
public without sharing class baf_SoqlHelper {
    @TestVisible private static final String NULL_VALUE = 'null';
    @TestVisible private static final String TRUE_VALUE = 'true';
    @TestVisible private static final String FALSE_VALUE = 'false';

    /**
     * Formats an Object value into a SOQL ready value based on data type of the given Field
     * @param   field   Schema.SObjectField The field this value is being matched to
     * @param   value   Object              The value to be formatted
     * @return      String  The converted value
     */
    public static String FormatForSoql(Schema.SObjectField field, Object value) {
        Schema.DisplayType fieldType = baf_SchemaHelper.GetDescribe(field).getType();
        if (fieldType == Schema.DisplayType.DATE) {
            Date xDate;
            try {
                xDate = Date.valueOf(String.valueOf(value));
            } catch (Exception ex) {
                return '';
            }
            return FormatDateForSoql(xDate);
        }
        if (fieldType == Schema.DisplayType.DATETIME) {
            DateTime xDateTime;
            try {
                xDateTime = DateTime.valueOf(String.valueOf(value));
            } catch (Exception ex) {
                return '';
            }
            return FormatDatetimeForSoql(xDateTime);
        }
        if (fieldType == Schema.DisplayType.DOUBLE
                || fieldType == Schema.DisplayType.INTEGER
                || fieldType == Schema.DisplayType.BASE64) {
            return String.valueOf(value);
        }
        if (fieldType == Schema.DisplayType.BOOLEAN) {
            Boolean xBoolean;
            try {
                xBoolean = Boolean.valueOf(String.valueOf(value));
            } catch (Exception ex) {
                return '';
            }
            return FormatBooleanForSoql(xBoolean);
        }
        return FormatStringForSoql(String.valueOf(value));
    }

    /**
     * Retrieve specific Field values from a list of SObject records as String
     * @param   field   Schema.SObjectField The field to retrieve values for
     * @param   records List<SObject>       The records to retrieve the field values from
     * @return      Set<String> The unique retrieved values
     */
    public static Set<String> GetValues(Schema.SObjectField field, List<SObject> records) {
        Set<String> values = new Set<String>();
        if (records == null || records.isEmpty()) { return values; }
        String fieldName = baf_SchemaHelper.GetDescribe(field).getName();
        for (SObject record : records) {
            Object fieldValue = record.get(fieldName);
            String fieldString = String.valueOf(fieldValue);
            if (fieldValue == null || values.contains(fieldString)) { continue; }
            values.add(fieldString);
        }
        return values;
    }

    /**
     * Retrieve specific Field values from a list of SObject records as Id
     * @param   field   Schema.SObjectField The field to retrieve values for
     * @param   records List<SObject>       The records to retrieve the field values from
     * @return      Set<Id> The unique retrieved values
     */
    public static Set<Id> GetIds(Schema.SObjectField field, List<SObject> records) {
        Set<Id> values = new Set<Id>();
        if (records == null || records.isEmpty()) { return values; }
        String fieldName = baf_SchemaHelper.GetDescribe(field).getName();
        for (SObject record : records) {
            Object fieldValue = record.get(fieldName);
            if (fieldValue == null) { continue; }
            Id idValue = (Id) String.valueOf(fieldValue);
            if (idValue == null || values.contains(idValue)) { continue; }
            values.add(idValue);
        }
        return values;
    }

    /**
     * Retrieve specific Field values from a list of SObject records as Id when for a specific SObjectType
     * @param   targetType  Schema.SObjectType  The Type of Id values desired
     * @param   field       Schema.SObjectField The field to retrieve values for
     * @param   records     List<SObject>       The records to retrieve the field values from
     * @return      Set<Id> The unique retrieved values
     */
    public static Set<Id> GetIdsFor(Schema.SObjectType targetType, Schema.SObjectField field, List<SObject> records) {
        Set<Id> values = GetIds(field, records);
        Set<Id> idSet = new Set<Id>();
        if (values == null || values.isEmpty()) { return idSet; }
        if (records == null || records.isEmpty()) { return idSet; }
        String keyPrefix = baf_SchemaHelper.GetDescribe(targetType).getKeyPrefix();
        for (Id value : values) {
            String sid = value;
            if (sid.startsWith(keyPrefix) && !idSet.contains(sid)) {
                idSet.add(value);
            }
        }
        return idSet;
    }

    /**
     * Pads the left side of a number with 0's as a String
     * @param   numDigitsAfterPad   Integer The total length the String should be
     * @param   numberToPad         Integer The number to pad left
     * @return      String
     */
    public static String AddLeadingZeros(Integer numDigitsAfterPad, Integer numberToPad) {
        if (numDigitsAfterPad == null || numberToPad == null) { return ''; }
        String num = String.valueOf(numberToPad);
        if (numDigitsAfterPad - num.length() <= 0) { return num; }
        return num.leftPad(numDigitsAfterPad, '0');
    }

    /**
     * Wraps a string in single quotes for use in SOQL
     * @param   source  String  The string to wrap
     * @return      String
     */
    public static String FormatStringForSoql(String source) {
        return String.isNotBlank(source) ? '\'' + String.escapeSingleQuotes(source) + '\'' : NULL_VALUE;
    }

    /**
     * Formats DateTime value to be used in SOQL
     * @param   source  DateTime    The DateTime value to format
     * @return      String
     */
    public static String FormatDatetimeForSoql(DateTime source) {
        return source != null ? source.formatGmt('yyyy-MM-dd HH:mm:ss').replace(' ', 'T')+'Z' : NULL_VALUE;
    }

    /**
     * Formats Date value to be used in SOQL
     * @param   source  Date    The Date value to format
     * @return      String
     */
    public static String FormatDateForSoql(Date source) {
        if (source == null) { return NULL_VALUE; }
        return String.valueOf(source.year())
                + addLeadingZeros(2, source.month())
                + addLeadingZeros(2, source.day());
    }

    /**
     * Formats Boolean value to be used in SOQL
     * @param   source  Boolean The Boolean value to format
     * @return      String
     */
    public static String FormatBooleanForSoql(Boolean source) {
        if (source == null) { return NULL_VALUE; }
        return source ? TRUE_VALUE : FALSE_VALUE;
    }

    /**
     * Formats a List<Object> to be used in SOQL
     * @param   field   Schema.SObjectField The field data type
     * @param   values  List<Object>        The values to format
     * @return      String
     */
    public static String FormatListForMatching(Schema.SObjectField field, List<Object> values) {
        String matchValues = '';
        for (Object value : values) {
            String formatted = formatForSoql(field, value);
            if (formatted == null || String.isBlank(formatted)) { continue; }
            if (matchValues.length() > 0) { matchValues += ', '; }
            matchValues += formatted;
        }
        return String.isNotBlank(matchValues) ? '(' + matchValues + ')' : matchValues;
    }

    /**
     * Formats an Object value based upon its underlying type
     * @param   value   Object  The value to re-format
     * @return      String
     */
    public static String FormattedValue(Object value) {
        if (value instanceOf Id) { return FormatStringForSoql(String.valueOf(value)); }
        if (value instanceOf Integer) { return String.valueOf(value); }
        if (value instanceOf Decimal) { return String.valueOf(value); }
        if (value instanceOf DateTime) { return FormatDatetimeForSoql((DateTime) value); }
        if (value instanceOf Date) { return FormatDateForSoql((Date) value); }
        if (value instanceOf Boolean) { return FormatBooleanForSoql((Boolean) value); }
        if (value instanceOf String) { return FormatStringForSoql(String.valueOf(value)); }

        return '';
    }
}