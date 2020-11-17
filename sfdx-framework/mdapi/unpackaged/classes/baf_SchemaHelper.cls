public with sharing class baf_SchemaHelper {
    // CONSTANTS
    private static final String DOT         = '.';
    private static final String COMMA_SPACE = ', ';

    // INTERNAL CACHE
    private static Map<Schema.SObjectType , Map<String, SObject>>       m_testDataCache         = new Map<Schema.SObjectType , Map<String, SObject>>();
    private static Map<Schema.SObjectType , DescribeSObjectResult>      m_sobjectDescribes      = new Map<Schema.SObjectType , DescribeSObjectResult>();
    private static Map<Schema.SObjectType , List<Schema.SObjectField>>  m_sobjectFields         = new Map<Schema.SObjectType , List<Schema.SObjectField>>();
    private static Map<Schema.SObjectType , List<Integer>>              m_sobjectFieldHashes    = new Map<Schema.SObjectType , List<Integer>>();
    private static Map<Schema.SObjectField, Integer>                    m_fieldHashes           = new Map<Schema.SObjectField, Integer>();
    private static Map<Integer, DescribeFieldResult>                    m_fieldDescribes        = new Map<Integer, DescribeFieldResult>();
    private static Map<Integer, Schema.SObjectType>                     m_objectsByFieldHash    = new Map<Integer, Schema.SObjectType>();
    private static Map<Integer, Schema.SObjectField>                    m_fieldsByHash          = new Map<Integer, Schema.SObjectField>();

    /**
     * Gets, and caches, the HASH representative of a SObjectField's uniqueness
     * @param   forField    Schema.SObjectField The field
     * @return      Integer
     */
    public static Integer GetFieldHash(Schema.SObjectField forField) {
        if (!m_fieldHashes.containsKey(forField)) { m_fieldHashes.put(forField, ((Object)forField).hashCode()); }
        return m_fieldHashes.get(forField);
    }

    /**
     * Gets, and caches, the DescribeSObjectResult for a given SObjectType
     * @param   forType Schema.SObjectType  The object to get describe details for
     * @return      DescribeSObjectResult
     */
    public static DescribeSObjectResult GetDescribe(Schema.SObjectType forType) {
        if (!m_sobjectDescribes.containsKey(forType)) { m_sobjectDescribes.put(forType, forType.getDescribe()); }
        return m_sobjectDescribes.get(forType);
    }

    /**
     * Gets, and caches, the DescribeFieldResult for a given SObjectField
     * @param   forField    Schema.SObjectField The Field to get describe details for
     * @return      DescribeFieldResult
     */
    public static DescribeFieldResult GetDescribe(Schema.SObjectField forField) {
        Integer hashForField = getFieldHash(forField);
        if (!m_fieldDescribes.containsKey(hashForField)) { m_fieldDescribes.put(hashForField, forField.getDescribe()); }
        return m_fieldDescribes.get(hashForField);
    }

    /**
     * Gets, and caches, the SObjectFields on a given SObjectType
     * @param   forType Schema.SObjectType  The object to get fields of
     * @return      List<Schema.SObjectField>
     */
    public static List<Schema.SObjectField> GetFields(Schema.SObjectType forType) {
        if (!m_sobjectFields.containsKey(forType)) { m_sobjectFields.put(forType, getDescribe(forType).fields.getMap().values()); }
        return m_sobjectFields.get(forType);
    }

    /**
     * Gets, and caches, the HASH uniqueness values for all FIELDS on an SObject
     * @param   forType Schema.SObjectType  The object to get field hash coces for
     * @return      List<Integer>
     */
    public static List<Integer> GetFieldHashes(Schema.SObjectType forType) {
        initializeFields(forType);
        return m_sobjectFieldHashes.get(forType);
    }

    private static Map<Schema.SObjectType, Integer> idsGenerated = new Map<Schema.SObjectType, Integer>();

    /**
     * Generates a functional Id value for a given SObjectType
     * @param   target  Schema.SObjectType
     * @return      Id
     */
    public static Id GenerateIdFor(Schema.SObjectType target) {
        Integer sequence = idsGenerated.get(target);
        if (sequence == null) { sequence = 0; }
        sequence++;
        idsGenerated.put(target, sequence);
        String result = String.valueOf(sequence);
        String key = getDescribe(target).getKeyPrefix() + '0'.repeat(12-result.length()) + result;
        //System.debug('GENERATED ID FOR ' + getDescribe(target).getName() + ' IS ' + key);
        return (Id) key;
    }

    private static void initializeFields(Schema.SObjectType forType) {
        if (!m_sobjectFieldHashes.containsKey(forType)) {
            List<Integer> hashes = new List<Integer>();
            for (Schema.SObjectField field : getFields(forType)) {
                Integer hashForField = getFieldHash(field);
                hashes.add(hashForField);
                if (!m_objectsByFieldHash.containsKey(hashForField)) { m_objectsByFieldHash.put(hashForField, forType); }
                if (!m_fieldsByHash.containsKey(hashForField)) { m_fieldsByHash.put(hashForField, field); }
            }
            m_sobjectFieldHashes.put(forType, hashes);
        }
    }

    private static Set<String> SETUP_OBJECTS = new Set<String> { 'ActionLinkGroupTemplate',
            'ActionLinkTemplate', 'AdminSetupEvent', 'AdminSetupEventStream', 'AggregateResult',
            'AnimationRule', 'ApexClass', 'ApexClassMember', 'ApexCodeCoverage',
            'ApexCodeCoverageAggregate', 'ApexComponent', 'ApexComponentMember',
            'ApexEmailNotification', 'ApexExecutionOverlayAction', 'ApexExecutionOverlayResult',
            'ApexLog', 'ApexOrgWideCoverage', 'ApexPage', 'ApexPageInfo', 'ApexPageMember',
            'ApexResult', 'ApexTestQueueItem', 'ApexTestResult', 'ApexTestResultLimits',
            'ApexTestRunResult', 'ApexTestSuite', 'ApexTrigger', 'ApexTriggerMember', 'ApiEvent',
            'ApiEventStream', 'AppAnalyticsQueryRequest', 'AppDefinition', 'AppMenuItem',
            'AppTabMember', 'AssetTokenEvent', 'AssignmentRule', 'AsyncApexJob', 'AsyncOperationEvent',
            'AsyncOperationStatus', 'AuraDefinition', 'AuraDefinitionBundle',
            'AuraDefinitionBundleInfo', 'AuraDefinitionInfo', 'AuthConfig', 'AuthConfigProviders',
            'AuthProvider', 'AuthSession', 'AutoResponseRule', 'BackgroundOperation',
            'BatchApexErrorEvent', 'BrandingSet', 'BrandingSetProperty', 'BrandTemplate',
            'BusinessHours', 'BusinessProcess', 'CampaignMemberStatus', 'CaseStatus', 'Certificate',
            'CleanDataService', 'CleanRule', 'ClientBrowser', 'ColorDefinition', 'Community',
            'CommunityWorkspacesNode', 'CompactLayout', 'CompactLayoutInfo', 'CompactLayoutItemInfo',
            'ConnectedApplication', 'ContainerAsyncRequest', 'ContentBody', 'ContentHubItem',
            'ContentHubRepository', 'ContentWorkspace', 'ContractStatus', 'CorsWhitelistEntry',
            'CronJobDetail', 'CronTrigger', 'CspTrustedSite', 'CustomApplication', 'CustomBrand',
            'CustomBrandAsset', 'CustomField', 'CustomFieldMember', 'CustomHelpMenuItem',
            'CustomHelpMenuSection', 'CustomHttpHeader', 'CustomNotificationType', 'CustomObject',
            'CustomObjectUserLicenseMetrics', 'CustomPermission', 'CustomPermissionDependency',
            'CustomTab', 'Dashboard', 'DashboardComponent', 'DataAssessmentConfigItem',
            'DataAssessmentFieldMetric', 'DataAssessmentMetric', 'DataAssessmentValueMetric',
            'DatacloudAddress', 'DataIntegrationRecordPurchasePermission', 'DataStatistics',
            'DataType', 'DataUseLegalBasis', 'DataUsePurpose', 'DebugLevel', 'DeployDetails',
            'DirectMessage', 'DirectMessageMember', 'Document', 'DocumentAttachmentMap', 'Domain',
            'DomainSite', 'DuplicateJobDefinition', 'DuplicateJobMatchingRuleDefinition',
            'DuplicateRecordItem', 'DuplicateRecordSet', 'DuplicateRule', 'EmailCapture',
            'EmailDomainFilter', 'EmailDomainKey', 'EmailMessage', 'EmailRelay',
            'EmailServicesAddress', 'EmailServicesFunction', 'EmailStatus', 'EmailTemplate',
            'EmbeddedServiceBranding', 'EmbeddedServiceConfig', 'EmbeddedServiceCustomLabel',
            'EmbeddedServiceDetail', 'EmbeddedServiceFieldService', 'EmbeddedServiceLabel',
            'EmbeddedServiceLiveAgent', 'EmbeddedServiceQuickAction', 'EngagementEvent',
            'EnhancedLetterhead', 'EntityDefinition', 'EntityLimit', 'EntityParticle',
            'EventBusSubscriber', 'EventDelivery', 'EventLogFile', 'EventSubscription',
            'ExpressionFilter', 'ExpressionFilterCriteria', 'ExternalDataSource',
            'ExternalDataUserAuth', 'ExternalServiceRegistration', 'ExternalString', 'FieldDefinition',
            'FieldMapping', 'FieldMappingField', 'FieldMappingRow', 'FieldPermissions',
            'FieldSecurityClassification', 'FieldSet', 'FileSearchActivity', 'FiscalYearSettings',
            'FlexiPage', 'FlexQueueItem', 'Flow', 'FlowDefinition', 'FlowDefinitionView',
            'FlowElementTestCoverage', 'FlowInterview', 'FlowTestCoverage', 'FlowVariableView',
            'FlowVersionView', 'ForecastingDisplayedFamily', 'FormulaFunction', 'FormulaOperator',
            'GlobalValueSet', 'GrantedByLicense', 'Group', 'GroupMember',
            'HeapDump', 'HistoryRetentionJob', 'Holiday', 'HomePageComponent', 'HomePageLayout',
            'IconDefinition', 'IdpEventLog', 'IframeWhiteListUrl', 'Index', 'IndexField',
            'InstalledMobileApp', 'InstalledSubscriberPackage', 'InstalledSubscriberPackageVersion',
            'KeywordList', 'KnowledgeableUser', 'Layout', 'LeadStatus', 'LightningComponentBundle',
            'LightningComponentResource', 'LightningExitByPageMetrics', 'LightningExperienceTheme',
            'LightningToggleMetrics', 'LightningUriEvent', 'LightningUriEventStream',
            'LightningUsageByAppTypeMetrics', 'LightningUsageByBrowserMetrics',
            'LightningUsageByFlexiPageMetrics', 'LightningUsageByPageMetrics', 'ListView',
            'ListViewChart', 'ListViewChartInstance', 'ListViewEvent', 'ListViewEventStream',
            'LoginAsEvent', 'LoginAsEventStream', 'LoginEvent', 'LoginEventStream', 'LoginGeo',
            'LoginIp', 'LogoutEvent', 'LogoutEventStream', 'LookupFilter', 'Macro', 'MacroInstruction',
            'MacroUsage', 'MailmergeTemplate', 'ManagedContentNodeType', 'ManagedContentType',
            'MatchingRule', 'MatchingRuleItem', 'MenuItem', 'MetadataComponentDependency',
            'MetadataContainer', 'MetadataPackage', 'MetadataPackageVersion', 'Metric',
            'MetricDataLink', 'MobileApplicationDetail', 'ModerationRule', 'MyDomainDiscoverableLogin',
            'Name', 'NamedCredential', 'NavigationLinkSet', 'NavigationMenuItem', 'Network',
            'NetworkActivityAudit', 'NetworkAffinity', 'NetworkDiscoverableLogin', 'NetworkMember',
            'NetworkMemberGroup', 'NetworkModeration', 'NetworkPageOverride', 'NetworkSelfRegistration',
            'NetworkUserHistoryRecent', 'OauthCustomScope', 'OauthToken', 'ObjectPermissions',
            'OnboardingMetrics', 'OperationLog', 'OpportunitySplitType', 'OpportunityStage',
            'Organization', 'OrgDeleteRequest', 'OrgLifecycleNotification', 'OrgWideEmailAddress',
            'OutgoingEmail', 'OwnerChangeOptionInfo', 'Package2', 'Package2Member', 'Package2Version',
            'Package2VersionCreateRequest', 'Package2VersionCreateRequestError',
            'PackageInstallRequest', 'PackageLicense', 'PackageUploadRequest',
            'PackageVersionUninstallRequestError', 'PathAssistant', 'PathAssistantStepInfo',
            'PathAssistantStepItem', 'Period', 'PermissionDependency', 'PermissionSet',
            'PermissionSetAssignment', 'PermissionSetGroup', 'PermissionSetGroupComponent',
            'PermissionSetLicense', 'PermissionSetLicenseAssign', 'PermissionSetPortalDelegate',
            'PermissionSetTabSetting', 'PicklistValueInfo', 'PlatformAction', 'PlatformCachePartition',
            'PlatformCachePartitionType', 'PlatformEventChannel', 'PlatformEventChannelMember',
            'PlatformStatusAlertEvent', 'PostTemplate', 'ProcessDefinition', 'ProcessInstance',
            'ProcessInstanceNode', 'ProcessInstanceStep', 'ProcessInstanceWorkitem', 'ProcessNode',
            'ProductConsumptionSchedule', 'Profile', 'ProfileLayout', 'Prompt', 'PromptAction',
            'PromptVersion', 'Publisher', 'PushTopic', 'PushUpgradeExcludedOrg', 'QueryResult',
            'QueueSobject', 'QuickActionDefinition', 'QuickActionList', 'QuickActionListItem',
            'QuickText', 'QuickTextUsage', 'RecentlyViewed', 'Recommendation', 'RecommendationStrategy',
            'RecordAction', 'RecordActionDeployment', 'RecordType', 'RelationshipDomain',
            'RelationshipInfo', 'RemoteProxy', 'Report', 'ReportEvent', 'ReportEventStream',
            'ReputationLevel', 'ReputationPointsRule', 'S2XEventMap', 'SamlSsoConfig', 'SandboxInfo',
            'SandboxProcess', 'Scontrol', 'SearchActivity', 'SearchLayout', 'SearchPromotionRule',
            'SecureAgent', 'SecureAgentPlugin', 'SecureAgentPluginProperty', 'SecureAgentsCluster',
            'SecurityCustomBaseline', 'SecurityHealthCheck', 'SecurityHealthCheckRisks',
            'ServiceFieldDataType', 'SessionPermSetActivation', 'SetupAuditTrail', 'SetupEntityAccess',
            'Site', 'SiteDetail', 'SiteIframeWhiteListUrl', 'SOQLResult', 'SolutionStatus',
            'SourceMember', 'Stamp', 'StampAssignment', 'StandardAction', 'StandardValueSet',
            'StaticResource', 'StreamingChannel', 'SubscriberPackage', 'SubscriberPackageVersion',
            'SubscriberPackageVersionUninstallRequest', 'SymbolTable', 'TabDefinition', 'TaskPriority',
            'TaskStatus', 'TenantUsageEntitlement', 'TestSuiteMembership', 'ThirdPartyAccountLink',
            'TimeSheetTemplate', 'TraceFlag', 'TransactionSecurityPolicy', 'TwoFactorInfo',
            'TwoFactorMethodsInfo', 'TwoFactorTempCode', 'UriEvent', 'UriEventStream', 'User',
            'UserAppInfo', 'UserAppMenuCustomization', 'UserAppMenuItem', 'UserCriteria',
            'UserCustomBadge', 'UserEmailPreferredPerson', 'UserEntityAccess', 'UserFieldAccess',
            'UserLicense', 'UserListView', 'UserListViewCriterion', 'UserLogin', 'UserPackageLicense',
            'UserPermissionAccess', 'UserPreference', 'UserProvAccount', 'UserProvAccountStaging',
            'UserProvisioningConfig', 'UserProvisioningLog', 'UserProvisioningRequest',
            'UserProvMockTarget', 'UserRecordAccess', 'UserRole', 'ValidationRule', 'VisualforceAccessMetrics',
            'WebLink', 'WorkflowAlert', 'WorkflowFieldUpdate', 'WorkflowOutboundMessage',
            'WorkflowRule', 'WorkflowTask', 'WorkSkillRouting', 'WorkSkillRoutingAttribute'
    };

    public static Boolean IsSetupSObject(Schema.SObjectType objectType) {
        if (objectType == null) { return false; }
        return SETUP_OBJECTS.contains(String.valueOf(objectType));
    }

    public static SObject GetSObjectFor(String name) {
        List<String> potentials = new List<String> { name, name+'__c', name.replace('__c','') };
        SObject retVal = null;
        for (String potential : potentials) {
            try {
                retVal = Schema.getGlobalDescribe().get(potential).newSObject();
                return retVal;
            }
            catch (Exception ignored) {}
        }
        return null;
    }

    public static String DetermineSObjectType(String name) {
        List<String> potentials = new List<String> { name, name+'__c', name.replace('__c','') };
        SObject retVal = null;
        for (String potential : potentials) {
            try {
                retVal = Schema.getGlobalDescribe().get(potential).newSObject();
                return potential;
            }
            catch (Exception ignored) {}
        }
        return name;
    }

    public static String DetermineFieldByLabel(String sObjectName, String fieldLabel) {
        SObjectType sobj = Schema.getGlobalDescribe().get(sObjectName);
        List<SObjectField> fields = GetFields(sobj);
        for (SObjectField field : fields) {
            DescribeFieldResult fr = GetDescribe(field);
            if (fr.getLabel() == fieldLabel) {
                return fr.name;
            }
        }
        return null;
    }

    public static Schema.SObjectField DetermineSObjectFieldByLabel(String sObjectName, String fieldLabel) {
        SObjectType sobj = Schema.getGlobalDescribe().get(sObjectName);
        List<SObjectField> fields = GetFields(sobj);
        for (SObjectField field : fields) {
            DescribeFieldResult fr = GetDescribe(field);
            if (fr.getLabel() == fieldLabel) {
                return field;
            }
        }
        return null;
    }

    public static SObject InjectFieldValues(SObject record, Map<String, Object> values) {
        // deserialize record prop to keep track of type assignment
        Map<String, Object> fieldMap = (Map<String, Object>) JSON.deserializeUntyped( JSON.serialize( record ) );

        // assign values from the suspended record prop/map
        for(String field : values.keySet()) {
            fieldMap.put(field, values.get(field));
        }

        // re-serialize the record prop from the field value map
        return (SObject) JSON.deserialize( JSON.serialize( fieldMap ), SObject.class );
    }

    public static List<String> GetPicklistValues(Schema.SObjectField field) {
        List<String> plValues = new List<String>();
        DescribeFieldResult dfr = GetDescribe(field);
        if (dfr.getType() != DisplayType.PICKLIST) { return plValues; }
        List<Schema.PicklistEntry> ples = dfr.getPicklistValues();
        for (Schema.PicklistEntry ple : ples) {
            plValues.add(ple.getLabel());
        }
        return plValues;
    }
}