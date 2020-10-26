/**
 * Provides a strongly-typed method of adding ORDER BY statements to generated SOQL
 */
public without sharing class baf_OrderBy implements baf_iOrderBy {
    @TestVisible private static final String ORDER_ASC = ' ASC';
    @TestVisible private static final String ORDER_DESC = ' DESC';

    private String m_baf_OrderBy { get; set; }
    
    /**
     * Execute generation of the ORDER BY statement as a String
     * @return      String
     */
    public String ForSoql() {
        return m_baf_OrderBy;
    }

    /**
     * Generates ORDER BY ASC
     * @param   field   Schema.SObjectField   The field to sort by
     * @return      A new instance of baf_OrderBy
     */
    public static baf_OrderBy Ascending(Schema.SObjectField field) {
        return new baf_OrderBy(field, ORDER_ASC);
    }

    /**
     * Generates ORDER BY DESC
     * @param   field   Schema.SObjectField   The field to sort by
     * @return      A new instance of baf_OrderBy
     */
    public static baf_OrderBy Descending(Schema.SObjectField field) {
        return new baf_OrderBy(field, ORDER_DESC);
    }

    private baf_OrderBy(Schema.SObjectField field, String direction) {
        m_baf_OrderBy = baf_SchemaHelper.GetDescribe(field).getName() + direction;
    }
}