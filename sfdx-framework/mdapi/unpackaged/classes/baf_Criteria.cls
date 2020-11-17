/**
 * Provides mechanisms for identifying SOQL filter critera and building of the SOQL WHERE clause.
 * Use of this pattern allows for easy tight-binding of SObjectField and prevents use of String-based field names.
 * This ensures healthier code and easier maintainability long term, especially in future refactoring efforts.
 */
public without sharing class baf_Criteria implements baf_iCriteria {
    @TestVisible private static final String LOG_PREFIX     = '[][][baf_Criteria] ';
    @TestVisible private static final String AND_BLOCK      = 'AND';
    @TestVisible private static final String OR_BLOCK       = 'OR';
    @TestVisible private static final String EQUAL_TO       = ' = ';
    @TestVisible private static final String NOT_EQUAL      = ' != ';
    @TestVisible private static final String GREATER_THAN   = ' > ';
    @TestVisible private static final String LESS_THAN      = ' < ';
    @TestVisible private static final String GREATER_EQUAL  = ' >= ';
    @TestVisible private static final String LESS_EQUAL     = ' <= ';
    @TestVisible private static final String VALUE_IN       = ' IN ';
    @TestVisible private static final String VALUE_NOT_IN   = ' NOT IN ';
    @TestVisible private static final String LIKE_TXT       = ' LIKE ';
    @TestVisible private static final String NOT_LIKE_TXT   = ' NOT LIKE ';
    @TestVisible private static final String LIKE_PRE       = '%';
    @TestVisible private static final String LIKE_POST      = '%';
    @TestVisible private static final String NULL_TXT       = 'NULL';

    private String m_singleCompare { get; set; }
    private Schema.SObjectField m_singleField { get; set; }
    private Object m_singleValue { get; set; }
    private List<Object> m_manyValues { get; set; }
    private String m_singlePre { get; set; }
    private String m_singlePost { get; set; }
    private List<baf_iCriteria> m_andCriteria { get; set; }
    private List<baf_iCriteria> m_orCriteria { get; set; }
    private baf_iQueryFactory m_subquery { get; set; }

    private baf_Criteria(List<baf_iCriteria> criterias, String typeOfList) {
        if (typeOfList == AND_BLOCK) { m_andCriteria = criterias; }
        if (typeOfList == OR_BLOCK) { m_orCriteria = criterias; }
    }

    private baf_Criteria(Schema.SObjectField field, String compare, baf_iQueryFactory subQuery) {
        m_singleField = field;
        m_singleCompare = compare;
        m_subquery = subQuery;
    }

    private baf_Criteria(Schema.SObjectField field, String compare, Object value) {
        m_singleField = field;
        m_singleCompare = compare;
        m_singleValue = value;
    }

    private baf_Criteria(Schema.SObjectField field, String compare, List<Object> values) {
        m_singleField = field;
        m_singleCompare = compare;
        m_manyValues = values;
    }

    private baf_Criteria(Schema.SObjectField field, String compare, Object value, String pre, String post) {
        m_singleField = field;
        m_singleCompare = compare;
        m_singleValue = value;
        m_singlePre = pre;
        m_singlePost = post;
    }

    /**
     * A grouping of baf_Criteria where all must be true
     * @param   criterias   List<baf_Criteria>   The list which must all be true
     * @return      A new instance of baf_Criteria
     */
    public static baf_iCriteria AndCriterias(List<baf_iCriteria> criterias) {
        return (baf_iCriteria) new baf_Criteria(criterias, AND_BLOCK);
    }

    /**
     * A grouping of baf_Criteria where just 1 must be true
     * @param   criterias   List<baf_Criteria>   The list where just 1 must be true
     * @return      A new instance of baf_Criteria
     */
    public static baf_iCriteria OrCriterias(List<baf_iCriteria> criterias) {
        return (baf_iCriteria) new baf_Criteria(criterias, OR_BLOCK);
    }

    /**
     * Builds a baf_Criteria where a given Schema.SObjectField must be Equal To a specified value
     * @param   field   Schema.SObjectField The field to compare
     * @param   value   Object              The value to be matched
     * @return      A new instance of baf_Criteria
     */
    public static baf_iCriteria Equals(Schema.SObjectField field, Object value) {
        return (baf_iCriteria) new baf_Criteria(field, EQUAL_TO, value);
    }

    /**
     * Builds a baf_Criteria where a given Schema.SObjectField must be Equal To a specified value
     * @param   field   Schema.SObjectField The field to compare
     * @param   value   Id                  The value to be matched
     * @return      A new instance of baf_Criteria
     */
    public static baf_iCriteria Equals(Schema.SObjectField field, Id value) {
        return (baf_iCriteria) new baf_Criteria(field, EQUAL_TO, (Object) String.valueOf(value));
    }

    /**
     * Builds a baf_Criteria where a given Schema.SObjectField must be Equal To a specified value
     * @param   field   Schema.SObjectField The field to compare
     * @param   value   String              The value to be matched
     * @return      A new instance of baf_Criteria
     */
    public static baf_iCriteria Equals(Schema.SObjectField field, String value) {
        return (baf_iCriteria) new baf_Criteria(field, EQUAL_TO, (Object) value);
    }

    /**
     * Builds a baf_Criteria where a given Schema.SObjectField must be Equal To a specified value
     * @param   field   Schema.SObjectField The field to compare
     * @param   value   Date                The value to be matched
     * @return      A new instance of baf_Criteria
     */
    public static baf_iCriteria Equals(Schema.SObjectField field, Date value) {
        return (baf_iCriteria) new baf_Criteria(field, EQUAL_TO, (Object) String.valueOf(value));
    }

    /**
     * Builds a baf_Criteria where a given Schema.SObjectField must be Equal To a specified value
     * @param   field   Schema.SObjectField The field to compare
     * @param   value   DateTime            The value to be matched
     * @return      A new instance of baf_Criteria
     */
    public static baf_iCriteria Equals(Schema.SObjectField field, DateTime value) {
        return (baf_iCriteria) new baf_Criteria(field, EQUAL_TO, (Object) String.valueOf(value));
    }

    /**
     * Builds a baf_Criteria where a given Schema.SObjectField must be Equal To a specified value
     * @param   field   Schema.SObjectField The field to compare
     * @param   value   Decimal             The value to be matched
     * @return      A new instance of baf_Criteria
     */
    public static baf_iCriteria Equals(Schema.SObjectField field, Decimal value) {
        return (baf_iCriteria) new baf_Criteria(field, EQUAL_TO, (Object) String.valueOf(value));
    }

    /**
     * Builds a baf_Criteria where a given Schema.SObjectField must be Equal To a specified value
     * @param   field   Schema.SObjectField The field to compare
     * @param   value   Integer             The value to be matched
     * @return      A new instance of baf_Criteria
     */
    public static baf_iCriteria Equals(Schema.SObjectField field, Integer value) {
        return (baf_iCriteria) new baf_Criteria(field, EQUAL_TO, (Object) String.valueOf(value));
    }

    /**
     * Builds a baf_Criteria where a given Schema.SObjectField must be Not Equal To a specified value
     * @param   field   Schema.SObjectField The field to compare
     * @param   value   Object              The value to be avoided
     * @return      A new instance of baf_Criteria
     */
    public static baf_iCriteria NotEquals(Schema.SObjectField field, Object value) {
        return (baf_iCriteria) new baf_Criteria(field, NOT_EQUAL, value);
    }

    /**
     * Builds a baf_Criteria where a given Schema.SObjectField must be Not Equal To a specified value
     * @param   field   Schema.SObjectField The field to compare
     * @param   value   Id                  The value to be avoided
     * @return      A new instance of baf_Criteria
     */
    public static baf_iCriteria NotEquals(Schema.SObjectField field, Id value) {
        return (baf_iCriteria) new baf_Criteria(field, NOT_EQUAL, (Object) String.valueOf(value));
    }

    /**
     * Builds a baf_Criteria where a given Schema.SObjectField must be Not Equal To a specified value
     * @param   field   Schema.SObjectField The field to compare
     * @param   value   String              The value to be avoided
     * @return      A new instance of baf_Criteria
     */
    public static baf_iCriteria NotEquals(Schema.SObjectField field, String value) {
        return (baf_iCriteria) new baf_Criteria(field, NOT_EQUAL, (Object) value);
    }

    /**
     * Builds a baf_Criteria where a given Schema.SObjectField must be Not Equal To a specified value
     * @param   field   Schema.SObjectField The field to compare
     * @param   value   Date                The value to be avoided
     * @return      A new instance of baf_Criteria
     */
    public static baf_iCriteria NotEquals(Schema.SObjectField field, Date value) {
        return (baf_iCriteria) new baf_Criteria(field, NOT_EQUAL, (Object) String.valueOf(value));
    }

    /**
     * Builds a baf_Criteria where a given Schema.SObjectField must be Not Equal To a specified value
     * @param   field   Schema.SObjectField The field to compare
     * @param   value   DateTime            The value to be avoided
     * @return      A new instance of baf_Criteria
     */
    public static baf_iCriteria NotEquals(Schema.SObjectField field, DateTime value) {
        return (baf_iCriteria) new baf_Criteria(field, NOT_EQUAL, (Object) String.valueOf(value));
    }

    /**
     * Builds a baf_Criteria where a given Schema.SObjectField must be Not Equal To a specified value
     * @param   field   Schema.SObjectField The field to compare
     * @param   value   Decimal             The value to be avoided
     * @return      A new instance of baf_Criteria
     */
    public static baf_iCriteria NotEquals(Schema.SObjectField field, Decimal value) {
        return (baf_iCriteria) new baf_Criteria(field, NOT_EQUAL, (Object) String.valueOf(value));
    }

    /**
     * Builds a baf_Criteria where a given Schema.SObjectField must be Not Equal To a specified value
     * @param   field   Schema.SObjectField The field to compare
     * @param   value   Integer             The value to be avoided
     * @return      A new instance of baf_Criteria
     */
    public static baf_iCriteria NotEquals(Schema.SObjectField field, Integer value) {
        return (baf_iCriteria) new baf_Criteria(field, NOT_EQUAL, (Object) String.valueOf(value));
    }

    /**
     * Builds a baf_Criteria where a given Schema.SObjectField must be Greater Than a specified value
     * @param   field   Schema.SObjectField The field to compare
     * @param   value   Object              The value to be compared
     * @return      A new instance of baf_Criteria
     */
    public static baf_iCriteria GreaterThan(Schema.SObjectField field, Object value) {
        return (baf_iCriteria) new baf_Criteria(field, GREATER_THAN, value);
    }

    /**
     * Builds a baf_Criteria where a given Schema.SObjectField must be Greater Than a specified value
     * @param   field   Schema.SObjectField The field to compare
     * @param   value   Date                The value to be compared
     * @return      A new instance of baf_Criteria
     */
    public static baf_iCriteria GreaterThan(Schema.SObjectField field, Date value) {
        return (baf_iCriteria) new baf_Criteria(field, GREATER_THAN, (Object) String.valueOf(value));
    }

    /**
     * Builds a baf_Criteria where a given Schema.SObjectField must be Greater Than a specified value
     * @param   field   Schema.SObjectField The field to compare
     * @param   value   DateTime             The value to be compared
     * @return      A new instance of baf_Criteria
     */
    public static baf_iCriteria GreaterThan(Schema.SObjectField field, DateTime value) {
        return (baf_iCriteria) new baf_Criteria(field, GREATER_THAN, (Object) String.valueOf(value));
    }

    /**
     * Builds a baf_Criteria where a given Schema.SObjectField must be Greater Than a specified value
     * @param   field   Schema.SObjectField The field to compare
     * @param   value   Decimal             The value to be compared
     * @return      A new instance of baf_Criteria
     */
    public static baf_iCriteria GreaterThan(Schema.SObjectField field, Decimal value) {
        return (baf_iCriteria) new baf_Criteria(field, GREATER_THAN, (Object) String.valueOf(value));
    }

    /**
     * Builds a baf_Criteria where a given Schema.SObjectField must be Greater Than a specified value
     * @param   field   Schema.SObjectField The field to compare
     * @param   value   Integer             The value to be compared
     * @return      A new instance of baf_Criteria
     */
    public static baf_iCriteria GreaterThan(Schema.SObjectField field, Integer value) {
        return (baf_iCriteria) new baf_Criteria(field, GREATER_THAN, (Object) String.valueOf(value));
    }

    /**
     * Builds a baf_Criteria where a given Schema.SObjectField must be Less Than a specified value
     * @param   field   Schema.SObjectField The field to compare
     * @param   value   Object              The value to be compared
     * @return      A new instance of baf_Criteria
     */
    public static baf_iCriteria LessThan(Schema.SObjectField field, Object value) {
        return (baf_iCriteria) new baf_Criteria(field, LESS_THAN, value);
    }

    /**
     * Builds a baf_Criteria where a given Schema.SObjectField must be Less Than a specified value
     * @param   field   Schema.SObjectField The field to compare
     * @param   value   Date                The value to be compared
     * @return      A new instance of baf_Criteria
     */
    public static baf_iCriteria LessThan(Schema.SObjectField field, Date value) {
        return (baf_iCriteria) new baf_Criteria(field, LESS_THAN, (Object) String.valueOf(value));
    }

    /**
     * Builds a baf_Criteria where a given Schema.SObjectField must be Less Than a specified value
     * @param   field   Schema.SObjectField The field to compare
     * @param   value   DateTime            The value to be compared
     * @return      A new instance of baf_Criteria
     */
    public static baf_iCriteria LessThan(Schema.SObjectField field, DateTime value) {
        return (baf_iCriteria) new baf_Criteria(field, LESS_THAN, (Object) String.valueOf(value));
    }

    /**
     * Builds a baf_Criteria where a given Schema.SObjectField must be Less Than a specified value
     * @param   field   Schema.SObjectField The field to compare
     * @param   value   Decimal             The value to be compared
     * @return      A new instance of baf_Criteria
     */
    public static baf_iCriteria LessThan(Schema.SObjectField field, Decimal value) {
        return (baf_iCriteria) new baf_Criteria(field, LESS_THAN, (Object) String.valueOf(value));
    }

    /**
     * Builds a baf_Criteria where a given Schema.SObjectField must be Less Than a specified value
     * @param   field   Schema.SObjectField The field to compare
     * @param   value   Integer             The value to be compared
     * @return      A new instance of baf_Criteria
     */
    public static baf_iCriteria LessThan(Schema.SObjectField field, Integer value) {
        return (baf_iCriteria) new baf_Criteria(field, LESS_THAN, (Object) String.valueOf(value));
    }

    /**
     * Builds a baf_Criteria where a given Schema.SObjectField must be Greater Than or Equal To a specified value
     * @param   field   Schema.SObjectField The field to compare
     * @param   value   Object              The value to be compared
     * @return      A new instance of baf_Criteria
     */
    public static baf_iCriteria GreaterThanOrEquals(Schema.SObjectField field, Object value) {
        return (baf_iCriteria) new baf_Criteria(field, GREATER_EQUAL, value);
    }

    /**
     * Builds a baf_Criteria where a given Schema.SObjectField must be Greater Than or Equal To a specified value
     * @param   field   Schema.SObjectField The field to compare
     * @param   value   Date                The value to be compared
     * @return      A new instance of baf_Criteria
     */
    public static baf_iCriteria GreaterThanOrEquals(Schema.SObjectField field, Date value) {
        return (baf_iCriteria) new baf_Criteria(field, GREATER_EQUAL, (Object) String.valueOf(value));
    }

    /**
     * Builds a baf_Criteria where a given Schema.SObjectField must be Greater Than or Equal To a specified value
     * @param   field   Schema.SObjectField The field to compare
     * @param   value   DateTime            The value to be compared
     * @return      A new instance of baf_Criteria
     */
    public static baf_iCriteria GreaterThanOrEquals(Schema.SObjectField field, DateTime value) {
        return (baf_iCriteria) new baf_Criteria(field, GREATER_EQUAL, (Object) String.valueOf(value));
    }

    /**
     * Builds a baf_Criteria where a given Schema.SObjectField must be Greater Than or Equal To a specified value
     * @param   field   Schema.SObjectField The field to compare
     * @param   value   Decimal             The value to be compared
     * @return      A new instance of baf_Criteria
     */
    public static baf_iCriteria GreaterThanOrEquals(Schema.SObjectField field, Decimal value) {
        return (baf_iCriteria) new baf_Criteria(field, GREATER_EQUAL, (Object) String.valueOf(value));
    }

    /**
     * Builds a baf_Criteria where a given Schema.SObjectField must be Greater Than or Equal To a specified value
     * @param   field   Schema.SObjectField The field to compare
     * @param   value   Integer             The value to be compared
     * @return      A new instance of baf_Criteria
     */
    public static baf_iCriteria GreaterThanOrEquals(Schema.SObjectField field, Integer value) {
        return (baf_iCriteria) new baf_Criteria(field, GREATER_EQUAL, (Object) String.valueOf(value));
    }

    /**
     * Builds a baf_Criteria where a given Schema.SObjectField must be Less Than or Equal To a specified value
     * @param   field   Schema.SObjectField The field to compare
     * @param   value   Object              The value to be compared
     * @return      A new instance of baf_Criteria
     */
    public static baf_iCriteria LessThanOrEquals(Schema.SObjectField field, Object value) {
        return (baf_iCriteria) new baf_Criteria(field, LESS_EQUAL, value);
    }

    /**
     * Builds a baf_Criteria where a given Schema.SObjectField must be Less Than or Equal To a specified value
     * @param   field   Schema.SObjectField The field to compare
     * @param   value   Date                The value to be compared
     * @return      A new instance of baf_Criteria
     */
    public static baf_iCriteria LessThanOrEquals(Schema.SObjectField field, Date value) {
        return (baf_iCriteria) new baf_Criteria(field, LESS_EQUAL, (Object) String.valueOf(value));
    }

    /**
     * Builds a baf_Criteria where a given Schema.SObjectField must be Less Than or Equal To a specified value
     * @param   field   Schema.SObjectField The field to compare
     * @param   value   DateTime            The value to be compared
     * @return      A new instance of baf_Criteria
     */
    public static baf_iCriteria LessThanOrEquals(Schema.SObjectField field, DateTime value) {
        return (baf_iCriteria) new baf_Criteria(field, LESS_EQUAL, (Object) String.valueOf(value));
    }

    /**
     * Builds a baf_Criteria where a given Schema.SObjectField must be Less Than or Equal To a specified value
     * @param   field   Schema.SObjectField The field to compare
     * @param   value   Decimal             The value to be compared
     * @return      A new instance of baf_Criteria
     */
    public static baf_iCriteria LessThanOrEquals(Schema.SObjectField field, Decimal value) {
        return (baf_iCriteria) new baf_Criteria(field, LESS_EQUAL, (Object) String.valueOf(value));
    }

    /**
     * Builds a baf_Criteria where a given Schema.SObjectField must be Less Than or Equal To a specified value
     * @param   field   Schema.SObjectField The field to compare
     * @param   value   Integer             The value to be compared
     * @return      A new instance of baf_Criteria
     */
    public static baf_iCriteria LessThanOrEquals(Schema.SObjectField field, Integer value) {
        return (baf_iCriteria) new baf_Criteria(field, LESS_EQUAL, (Object) String.valueOf(value));
    }

    /**
     * Builds a baf_Criteria where a given Schema.SObjectField's value must be in a list of values
     * @param   field   Schema.SObjectField The field to compare
     * @param   values  Set<Object>         The values to be compared
     * @return      A new instance of baf_Criteria
     */
    public static baf_iCriteria ValueIn(Schema.SObjectField field, Set<Object> values) {
        List<Object> newValues = new List<Object>();
        for (Object value : values) { newValues.add(value); }
        return ValueIn(field, newValues);
    }

    /**
     * Builds a baf_Criteria where a given Schema.SObjectField's value must be in a list of values
     * @param   field   Schema.SObjectField The field to compare
     * @param   values  Set<Id>             The values to be compared
     * @return      A new instance of baf_Criteria
     */
    public static baf_iCriteria ValueIn(Schema.SObjectField field, Set<Id> values) {
        List<Object> newValues = new List<Object>();
        for (Id value : values) { newValues.add((Object) String.valueOf(value)); }
        return ValueIn(field, newValues);
    }

    /**
     * Builds a baf_Criteria where a given Schema.SObjectField's value must be in a list of values
     * @param   field   Schema.SObjectField The field to compare
     * @param   values  Set<String>         The values to be compared
     * @return      A new instance of baf_Criteria
     */
    public static baf_iCriteria ValueIn(Schema.SObjectField field, Set<String> values) {
        List<Object> newValues = new List<Object>();
        for (String value : values) { newValues.add((Object) value); }
        return ValueIn(field, newValues);
    }

    /**
     * Builds a baf_Criteria where a given Schema.SObjectField's value must be in a list of values
     * @param   field   Schema.SObjectField The field to compare
     * @param   values  Set<Date>           The values to be compared
     * @return      A new instance of baf_Criteria
     */
    public static baf_iCriteria ValueIn(Schema.SObjectField field, Set<Date> values) {
        List<Object> newValues = new List<Object>();
        for (Date value : values) { newValues.add((Object) String.valueOf(value)); }
        return ValueIn(field, newValues);
    }

    /**
     * Builds a baf_Criteria where a given Schema.SObjectField's value must be in a list of values
     * @param   field   Schema.SObjectField The field to compare
     * @param   values  Set<DateTime>       The values to be compared
     * @return      A new instance of baf_Criteria
     */
    public static baf_iCriteria ValueIn(Schema.SObjectField field, Set<DateTime> values) {
        List<Object> newValues = new List<Object>();
        for (DateTime value : values) { newValues.add((Object) String.valueOf(value)); }
        return ValueIn(field, newValues);
    }

    /**
     * Builds a baf_Criteria where a given Schema.SObjectField's value must be in a list of values
     * @param   field   Schema.SObjectField The field to compare
     * @param   values  Set<Decimal>        The values to be compared
     * @return      A new instance of baf_Criteria
     */
    public static baf_iCriteria ValueIn(Schema.SObjectField field, Set<Decimal> values) {
        List<Object> newValues = new List<Object>();
        for (Decimal value : values) { newValues.add((Object) String.valueOf(value)); }
        return ValueIn(field, newValues);
    }

    /**
     * Builds a baf_Criteria where a given Schema.SObjectField's value must be in a list of values
     * @param   field   Schema.SObjectField The field to compare
     * @param   values  Set<Integer>        The values to be compared
     * @return      A new instance of baf_Criteria
     */
    public static baf_iCriteria ValueIn(Schema.SObjectField field, Set<Integer> values) {
        List<Object> newValues = new List<Object>();
        for (Integer value : values) { newValues.add((Object) String.valueOf(value)); }
        return ValueIn(field, newValues);
    }

    /**
     * Builds a baf_Criteria where a given Schema.SObjectField's value must be in a list of values
     * @param   field   Schema.SObjectField The field to compare
     * @param   values  List<Object>        The values to be compared
     * @return      A new instance of baf_Criteria
     */
    public static baf_iCriteria ValueIn(Schema.SObjectField field, List<Object> values) {
        return (baf_iCriteria) new baf_Criteria(field, VALUE_IN, values);
    }

    /**
     * Builds a baf_Criteria where a given Schema.SObjectField's value must be in a list of values
     * @param   field   Schema.SObjectField The field to compare
     * @param   values  List<Id>            The values to be compared
     * @return      A new instance of baf_Criteria
     */
    public static baf_iCriteria ValueIn(Schema.SObjectField field, List<Id> values) {
        List<Object> newValues = new List<Object>();
        for (Id value : values) { newValues.add((Object) String.valueOf(value)); }
        return ValueIn(field, newValues);
    }

    /**
     * Builds a baf_Criteria where a given Schema.SObjectField's value must be in a list of values
     * @param   field   Schema.SObjectField The field to compare
     * @param   values  List<String>        The values to be compared
     * @return      A new instance of baf_Criteria
     */
    public static baf_iCriteria ValueIn(Schema.SObjectField field, List<String> values) {
        List<Object> newValues = new List<Object>();
        for (String value : values) { newValues.add((Object) value); }
        return ValueIn(field, newValues);
    }

    /**
     * Builds a baf_Criteria where a given Schema.SObjectField's value must be in a list of values
     * @param   field   Schema.SObjectField The field to compare
     * @param   values  List<Date>          The values to be compared
     * @return      A new instance of baf_Criteria
     */
    public static baf_iCriteria ValueIn(Schema.SObjectField field, List<Date> values) {
        List<Object> newValues = new List<Object>();
        for (Date value : values) { newValues.add((Object) String.valueOf(value)); }
        return ValueIn(field, newValues);
    }

    /**
     * Builds a baf_Criteria where a given Schema.SObjectField's value must be in a list of values
     * @param   field   Schema.SObjectField The field to compare
     * @param   values  List<DateTime>      The values to be compared
     * @return      A new instance of baf_Criteria
     */
    public static baf_iCriteria ValueIn(Schema.SObjectField field, List<DateTime> values) {
        List<Object> newValues = new List<Object>();
        for (DateTime value : values) { newValues.add((Object) String.valueOf(value)); }
        return ValueIn(field, newValues);
    }

    /**
     * Builds a baf_Criteria where a given Schema.SObjectField's value must be in a list of values
     * @param   field   Schema.SObjectField The field to compare
     * @param   values  List<Decimal>       The values to be compared
     * @return      A new instance of baf_Criteria
     */
    public static baf_iCriteria ValueIn(Schema.SObjectField field, List<Decimal> values) {
        List<Object> newValues = new List<Object>();
        for (Decimal value : values) { newValues.add((Object) String.valueOf(value)); }
        return ValueIn(field, newValues);
    }

    /**
     * Builds a baf_Criteria where a given Schema.SObjectField's value must be in a list of values
     * @param   field   Schema.SObjectField The field to compare
     * @param   values  List<Integer>       The values to be compared
     * @return      A new instance of baf_Criteria
     */
    public static baf_iCriteria ValueIn(Schema.SObjectField field, List<Integer> values) {
        List<Object> newValues = new List<Object>();
        for (Integer value : values) { newValues.add((Object) String.valueOf(value)); }
        return ValueIn(field, newValues);
    }

    /**
     * Builds a baf_Criteria where a given Schema.SObjectField's value must be in a list of values
     * @param   field       Schema.SObjectField The field to compare
     * @param   subQuery    baf_iQueryFactory        A query to find the values in
     * @return      A new instance of baf_Criteria
     */
    public static baf_iCriteria ValueIn(Schema.SObjectField field, baf_iQueryFactory subQuery) {
        return (baf_iCriteria) new baf_Criteria(field, VALUE_IN, subQuery);
    }

    /**
     * Builds a baf_Criteria where a given Schema.SObjectField's value must NOT be in a list of values
     * @param   field   Schema.SObjectField The field to compare
     * @param   values  Set<Object>         The values to be compared
     * @return      A new instance of baf_Criteria
     */
    public static baf_iCriteria ValueNotIn(Schema.SObjectField field, Set<Object> values) {
        List<Object> newValues = new List<Object>();
        for (Object value : values) { newValues.add(value); }
        return ValueNotIn(field, newValues);
    }

    /**
     * Builds a baf_Criteria where a given Schema.SObjectField's value must NOT be in a list of values
     * @param   field   Schema.SObjectField The field to compare
     * @param   values  Set<Id>             The values to be compared
     * @return      A new instance of baf_Criteria
     */
    public static baf_iCriteria ValueNotIn(Schema.SObjectField field, Set<Id> values) {
        List<Object> newValues = new List<Object>();
        for (Id value : values) { newValues.add((Object) String.valueOf(value)); }
        return ValueNotIn(field, newValues);
    }

    /**
     * Builds a baf_Criteria where a given Schema.SObjectField's value must NOT be in a list of values
     * @param   field   Schema.SObjectField The field to compare
     * @param   values  Set<String>         The values to be compared
     * @return      A new instance of baf_Criteria
     */
    public static baf_iCriteria ValueNotIn(Schema.SObjectField field, Set<String> values) {
        List<Object> newValues = new List<Object>();
        for (String value : values) { newValues.add((Object) value); }
        return ValueNotIn(field, newValues);
    }

    /**
     * Builds a baf_Criteria where a given Schema.SObjectField's value must NOT be in a list of values
     * @param   field   Schema.SObjectField The field to compare
     * @param   values  Set<Date>           The values to be compared
     * @return      A new instance of baf_Criteria
     */
    public static baf_iCriteria ValueNotIn(Schema.SObjectField field, Set<Date> values) {
        List<Object> newValues = new List<Object>();
        for (Date value : values) { newValues.add((Object) String.valueOf(value)); }
        return ValueNotIn(field, newValues);
    }

    /**
     * Builds a baf_Criteria where a given Schema.SObjectField's value must NOT be in a list of values
     * @param   field   Schema.SObjectField The field to compare
     * @param   values  Set<DateTime>       The values to be compared
     * @return      A new instance of baf_Criteria
     */
    public static baf_iCriteria ValueNotIn(Schema.SObjectField field, Set<DateTime> values) {
        List<Object> newValues = new List<Object>();
        for (DateTime value : values) { newValues.add((Object) String.valueOf(value)); }
        return ValueNotIn(field, newValues);
    }

    /**
     * Builds a baf_Criteria where a given Schema.SObjectField's value must NOT be in a list of values
     * @param   field   Schema.SObjectField The field to compare
     * @param   values  Set<Decimal>        The values to be compared
     * @return      A new instance of baf_Criteria
     */
    public static baf_iCriteria ValueNotIn(Schema.SObjectField field, Set<Decimal> values) {
        List<Object> newValues = new List<Object>();
        for (Decimal value : values) { newValues.add((Object) String.valueOf(value)); }
        return ValueNotIn(field, newValues);
    }

    /**
     * Builds a baf_Criteria where a given Schema.SObjectField's value must NOT be in a list of values
     * @param   field   Schema.SObjectField The field to compare
     * @param   values  Set<Integer>        The values to be compared
     * @return      A new instance of baf_Criteria
     */
    public static baf_iCriteria ValueNotIn(Schema.SObjectField field, Set<Integer> values) {
        List<Object> newValues = new List<Object>();
        for (Integer value : values) { newValues.add((Object) String.valueOf(value)); }
        return ValueNotIn(field, newValues);
    }

    /**
     * Builds a baf_Criteria where a given Schema.SObjectField's value must NOT be in a list of values
     * @param   field   Schema.SObjectField The field to compare
     * @param   values  List<Object>        The values to be compared
     * @return      A new instance of baf_Criteria
     */
    public static baf_iCriteria ValueNotIn(Schema.SObjectField field, List<Object> values) {
        return (baf_iCriteria) new baf_Criteria(field, VALUE_NOT_IN, values);
    }

    /**
     * Builds a baf_Criteria where a given Schema.SObjectField's value must NOT be in a list of values
     * @param   field   Schema.SObjectField The field to compare
     * @param   values  List<Id>            The values to be compared
     * @return      A new instance of baf_Criteria
     */
    public static baf_iCriteria ValueNotIn(Schema.SObjectField field, List<Id> values) {
        List<Object> newValues = new List<Object>();
        for (Id value : values) { newValues.add((Object) String.valueOf(value)); }
        return ValueNotIn(field, newValues);
    }

    /**
     * Builds a baf_Criteria where a given Schema.SObjectField's value must NOT be in a list of values
     * @param   field   Schema.SObjectField The field to compare
     * @param   values  List<String>        The values to be compared
     * @return      A new instance of baf_Criteria
     */
    public static baf_iCriteria ValueNotIn(Schema.SObjectField field, List<String> values) {
        List<Object> newValues = new List<Object>();
        for (String value : values) { newValues.add((Object) value); }
        return ValueNotIn(field, newValues);
    }

    /**
     * Builds a baf_Criteria where a given Schema.SObjectField's value must NOT be in a list of values
     * @param   field   Schema.SObjectField The field to compare
     * @param   values  List<Date>          The values to be compared
     * @return      A new instance of baf_Criteria
     */
    public static baf_iCriteria ValueNotIn(Schema.SObjectField field, List<Date> values) {
        List<Object> newValues = new List<Object>();
        for (Date value : values) { newValues.add((Object) String.valueOf(value)); }
        return ValueNotIn(field, newValues);
    }

    /**
     * Builds a baf_Criteria where a given Schema.SObjectField's value must NOT be in a list of values
     * @param   field   Schema.SObjectField The field to compare
     * @param   values  List<DateTime>      The values to be compared
     * @return      A new instance of baf_Criteria
     */
    public static baf_iCriteria ValueNotIn(Schema.SObjectField field, List<DateTime> values) {
        List<Object> newValues = new List<Object>();
        for (DateTime value : values) { newValues.add((Object) String.valueOf(value)); }
        return ValueNotIn(field, newValues);
    }

    /**
     * Builds a baf_Criteria where a given Schema.SObjectField's value must NOT be in a list of values
     * @param   field   Schema.SObjectField The field to compare
     * @param   values  List<Decimal>       The values to be compared
     * @return      A new instance of baf_Criteria
     */
    public static baf_iCriteria ValueNotIn(Schema.SObjectField field, List<Decimal> values) {
        List<Object> newValues = new List<Object>();
        for (Decimal value : values) { newValues.add((Object) String.valueOf(value)); }
        return ValueNotIn(field, newValues);
    }

    /**
     * Builds a baf_Criteria where a given Schema.SObjectField's value must NOT be in a list of values
     * @param   field   Schema.SObjectField The field to compare
     * @param   values  List<Integer>       The values to be compared
     * @return      A new instance of baf_Criteria
     */
    public static baf_iCriteria ValueNotIn(Schema.SObjectField field, List<Integer> values) {
        List<Object> newValues = new List<Object>();
        for (Integer value : values) { newValues.add((Object) String.valueOf(value)); }
        return ValueNotIn(field, newValues);
    }

    /**
     * Builds a baf_Criteria where a given Schema.SObjectField's value must NOT be in a list of values
     * @param   field       Schema.SObjectField The field to compare
     * @param   subQuery    baf_iQueryFactory        A query to find the values in
     * @return      A new instance of baf_Criteria
     */
    public static baf_iCriteria ValueNotIn(Schema.SObjectField field, baf_iQueryFactory subQuery) {
        return (baf_iCriteria) new baf_Criteria(field, VALUE_NOT_IN, subQuery);
    }

    /**
     * Builds a baf_Criteria where a given Schema.SObjectField's value must begin with specified text
     * @param   field   Schema.SObjectField The field to compare
     * @param   values  String              The values to be compared
     * @return      A new instance of baf_Criteria
     */
    public static baf_iCriteria BeginsWith(Schema.SObjectField field, String value) {
        return (baf_iCriteria) new baf_Criteria(field, LIKE_TXT, value, null, LIKE_POST);
    }

    /**
     * Builds a baf_Criteria where a given Schema.SObjectField's value must contain specified text
     * @param   field   Schema.SObjectField The field to compare
     * @param   values  String              The values to be compared
     * @return      A new instance of baf_Criteria
     */
    public static baf_iCriteria Contains(Schema.SObjectField field, String value) {
        return (baf_iCriteria) new baf_Criteria(field, LIKE_TXT, value, LIKE_PRE, LIKE_POST);
    }

    /**
     * Builds a baf_Criteria where a given Schema.SObjectField's value must end with specified text
     * @param   field   Schema.SObjectField The field to compare
     * @param   values  String              The values to be compared
     * @return      A new instance of baf_Criteria
     */
    public static baf_iCriteria EndsWith(Schema.SObjectField field, String value) {
        return (baf_iCriteria) new baf_Criteria(field, LIKE_TXT, value, LIKE_PRE, null);
    }

    /**
     * Builds a baf_Criteria where a given Schema.SObjectField's value must NOT begin with specified text
     * @param   field   Schema.SObjectField The field to compare
     * @param   values  String              The values to be compared
     * @return      A new instance of baf_Criteria
     */
    public static baf_iCriteria DoesNotBeginWith(Schema.SObjectField field, String value) {
        return (baf_iCriteria) new baf_Criteria(field, NOT_LIKE_TXT, value, null, LIKE_POST);
    }

    /**
     * Builds a baf_Criteria where a given Schema.SObjectField's value must NOT contain specified text
     * @param   field   Schema.SObjectField The field to compare
     * @param   values  String              The values to be compared
     * @return      A new instance of baf_Criteria
     */
    public static baf_iCriteria DoesNotContain(Schema.SObjectField field, String value) {
        return (baf_iCriteria) new baf_Criteria(field, NOT_LIKE_TXT, value, LIKE_PRE, LIKE_POST);
    }

    /**
     * Builds a baf_Criteria where a given Schema.SObjectField's value must NOT end with specified text
     * @param   field   Schema.SObjectField The field to compare
     * @param   values  String              The values to be compared
     * @return      A new instance of baf_Criteria
     */
    public static baf_iCriteria DoesNotEndWith(Schema.SObjectField field, String value) {
        return (baf_iCriteria) new baf_Criteria(field, NOT_LIKE_TXT, value, LIKE_PRE, null);
    }

    /**
     * Builds a baf_Criteria where a given Schema.SObjectField's value must be null
     * @param   field   Schema.SObjectField The field to compare
     * @return      A new instance of baf_Criteria
     */
    public static baf_iCriteria IsNull(Schema.SObjectField field) {
        return (baf_iCriteria) new baf_Criteria(field, EQUAL_TO, (Object) null);
    }

    /**
     * Builds a baf_Criteria where a given Schema.SObjectField's value must NOT be null
     * @param   field   Schema.SObjectField The field to compare
     * @return      A new instance of baf_Criteria
     */
    public static baf_iCriteria IsNotNull(Schema.SObjectField field) {
        return (baf_iCriteria) new baf_Criteria(field, NOT_EQUAL, (Object) null);
    }

    /**
     * Generates SOQL WHERE clause string representing this an all nested baf_Criteria
     * @return      String, the SOQL WHERE clause to be executed
     */
    public String ForSoql() {
        String soql = generateBlock();
        if (soql != null && String.isNotBlank(soql)) { return soql; }
        soql = '';
        soql += baf_SchemaHelper.GetDescribe(m_singleField).getName();
        soql += m_singleCompare;
        if (m_subquery != null) {
            soql += '(' + m_subquery.GenerateSoql() + ')';
            return soql;
        }
        if ((m_singleCompare == EQUAL_TO || m_singleCompare == NOT_EQUAL) && m_singleValue == null) {
            return soql + NULL_TXT;
        }
        if (m_manyValues != null) {
            String formattedList = baf_SoqlHelper.FormatListForMatching(m_singleField, m_manyValues);
            if (formattedList == null) {
                System.debug(LoggingLevel.Error, LOG_PREFIX + 'Failed to convert values in List.');
                return '';
            }
            return soql + formattedList;
        }
        String targetValue = String.valueOf(m_singleValue);
        if (m_singlePre != null) { targetValue = m_singlePre + targetValue; }
        if (m_singlePost != null) { targetValue = targetValue + m_singlePost; }
        String formattedValue = baf_SoqlHelper.FormatForSoql(m_singleField, (Object)targetValue);
        if (formattedValue == null) {
            System.debug(LoggingLevel.Error, LOG_PREFIX + 'Failed to convert value for baf_Criteria.');
            return '';
        }
        return soql + formattedValue;
    }

    private String generateBlock() {
        String junction = m_andCriteria != null && !m_andCriteria.isEmpty()
                ? AND_BLOCK : OR_BLOCK;
        List<baf_iCriteria> criterias = m_andCriteria != null && !m_andCriteria.isEmpty()
                ? m_andCriteria : m_orCriteria;
        if (criterias == null || criterias.isEmpty()) { return ''; }
        String soql = '';
        for (baf_iCriteria criteria : criterias) {
            String formattedComparison = criteria.ForSoql();
            if (formattedComparison == null || String.isBlank(formattedComparison)) { continue; }
            if (soql.length() > 1) { soql += ' ' + junction + ' '; }
            soql += formattedComparison;
        }
        return '(' + soql + ')';
    }
}