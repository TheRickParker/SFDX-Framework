/**
 * Builds and executes a query against an SObject using provided parameters.
 */
public interface baf_iQueryFactory {
    /**
     * Retrieves the SObjectType that this baf_QueryFactory is generating SOQL on behalf of
     * @return  Schema.SObjectType
     */
    Schema.SObjectType GetUnderlyingType();

    /**
     * Fluently adds a field to the SELECT portion of the Query
     * @param  field    Schema.SObjectField The SObjectField to include in the Query
     * @return       The current instance of this baf_QueryFactory
     */
    baf_iQueryFactory WithField(Schema.SObjectField field);

    /**
     * Fluently adds a field to the SELECT portion of the Query
     * @param  fields   List<Schema.SObjectField>   The SObjectFields to include in the Query
     * @return          The current instance of this baf_QueryFactory
     */
    baf_iQueryFactory WithFields(List<Schema.SObjectField> fields);

    /**
     * Fluently applies a field from a related SObject to include in the query
     * @param  relatedField     Schema.SObjectField SObjectField on local SObject that holds the relationship
     * @param  fieldOnRelation  Schema.SObjectField SObjectField on a related SObject to include in the query
     * @return       The current instance of this baf_QueryFactory
     */
    baf_iQueryFactory WithRelatedField(Schema.SObjectField relatedField, Schema.SObjectField fieldOnRelation);

    /**
     * Fluently applies a field from a related SObject to include in the query
     * @param  relatedField     Schema.SObjectField SObjectField on local SObject that holds the relationship
     * @param  relatedField2    Schema.SObjectField SObjectField on local SObject that holds the relationship
     * @param  fieldOnRelation  Schema.SObjectField SObjectField on a related SObject to include in the query
     * @return       The current instance of this baf_QueryFactory
     */
    baf_iQueryFactory WithRelatedField(Schema.SObjectField relatedField
            , Schema.SObjectField relatedField2, Schema.SObjectField fieldOnRelation);

    /**
     * Fluently applies a field from a related SObject to include in the query
     * @param  relatedField     Schema.SObjectField SObjectField on local SObject that holds the relationship
     * @param  relatedField2    Schema.SObjectField SObjectField on local SObject that holds the relationship
     * @param  relatedField3    Schema.SObjectField SObjectField on local SObject that holds the relationship
     * @param  fieldOnRelation  Schema.SObjectField SObjectField on a related SObject to include in the query
     * @return       The current instance of this baf_QueryFactory
     */
    baf_iQueryFactory WithRelatedField(Schema.SObjectField relatedField
            , Schema.SObjectField relatedField2, Schema.SObjectField relatedField3, Schema.SObjectField fieldOnRelation);

    /**
     * Fluently applies a Child query to include in the results
     * @param  child    baf_QueryFactory A Child query to include in the results
     * @return       The current instance of this baf_QueryFactory
     */
    baf_iQueryFactory WithChildQuery(baf_iQueryFactory child);

    /**
     * Fluently applies the baf_Criteria used for the Query
     * @param  conditions baf_Criteria   The baf_Criteria to use to filter the Query
     * @return            The current instance of this baf_QueryFactory
     */
    baf_iQueryFactory WithCriteria(baf_iCriteria conditions);

    /**
     * Fluently clears the existing sort order, if any
     * @return   The current instance of this baf_QueryFactory
     */
    baf_iQueryFactory ClearExistingOrder();

    /**
     * Fluently applies the sort order for the Query
     * @param  orderBy  baf_OrderBy    Sort order for the resulting Query
     * @return         The current instance of this baf_QueryFactory
     */
    baf_iQueryFactory WithOrderBy(baf_iOrderBy orderBy);

    /**
     * Fluently applies the sort order for the Query
     * @param  orderBys List<baf_OrderBy>  Sort order for the resulting Query
     * @return         The current instance of this baf_QueryFactory
     */
    baf_iQueryFactory WithOrderBys(List<baf_iOrderBy> orderBys);

    /**
     * Fluently adds a field to the sorting of the Query
     * @param  field    Schema.SObjectField The SObjectField to sort by Ascending
     * @return       The current instance of this baf_QueryFactory
     */
    baf_iQueryFactory OrderAscending(Schema.SObjectField field);

    /**
     * Fluently adds a field to the sorting of the Query
     * @param  field    Schema.SObjectField The SObjectField to sort by Descending
     * @return       The current instance of this baf_QueryFactory
     */
    baf_iQueryFactory OrderDescending(Schema.SObjectField field);

    /**
     * Fluently applies a Row Limit to the Query results
     * @param  rowLimit Integer The number of rows to retrieve
     * @return          The current instance of this baf_QueryFactory
     */
    baf_iQueryFactory WithRowLimit(Integer rowLimit);

    /**
     * Generates the SOQL statement used to perform the Query
     * @return   String
     */
    String GenerateSoql();

    /**
     * Generates the SOQL for nesting inside another query
     * @param   relateOn    String  relationship name to use instead of SObjectName
     * @return  String
     */
    String GenerateSoqlNested(String relateOn);

    /**
     * Executes the query produced by GenerateSoql() method
     * @return   List<SObject>
     */
    List<SObject> Execute();
}