using System;
using System.Collections.Generic;
using formioCommon.Constants;

namespace formioModels.Data
{
    public class DataSetSearchCriteriaInputModel : SearchCriteriaInputModelBase
    {
        public DataSetSearchCriteriaInputModel() : base(InputTypeGuidConstants.DataSetSearchCriteriaInputCommandTypeGuid)
        {
        }

        public Guid? Id { get; set; }
        public Guid? DataSourceId { get; set; }
        public string DataJsonKeyName { get; set; }
        public object DataJsonKeyValue { get; set; }
        public string KeyName { get; set; }
        public bool? IsPagingRequired { get; set; }
        public List<ParamsJsonModel> DataJsonInputs { get; set; }
        public bool? IsInnerQuery { get; set; }
        public bool? ForFormFieldValue { get; set; }
        public string KeyValue { get; set; }
        public bool? ForRecordValue { get; set; }
        public string Paths { get; set; }
        public List<Guid> CompanyIds { get; set; }
        public bool AdvancedFilter { get; set; }
        public List<FieldSearchModel> Fields { get; set; }
        public List<string> KeyFilterJson { get; set; }
        public string UniqueField { get; set; }
        public string UniqueFieldValue { get; set; }
        public List<Guid> DataSourceIds { get; set; }
        public List<Guid> DataSetIds { get; set; }
        public bool IsRecordLevelPermissionEnabled { get; set; }
        public int ConditionalEnum { get; set; }
        public string RoleIds { get; set; }
        public List<RecordLevelPermissionInputModel> RecordFilters { get; set; }
    }
    public class FieldSearchModel
    {
        public string Field { get; set; }
        public string Operator { get; set; }
        public string Value { get; set; }
    }
    public class RecordLevelPermissionInputModel
    {
        public string UserIds { get; set; }
        public string RoleIds { get; set; }
        public List<FieldPermissionModel> Fields { get; set; }
    }

    public class FieldPermissionModel
    {
        public string FieldName { get; set; }
        public string FieldValue { get; set; }
        public string Condition { get; set; }

    }
}
