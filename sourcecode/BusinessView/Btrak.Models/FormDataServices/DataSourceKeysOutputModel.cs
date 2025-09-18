//using MongoDB.Bson.Serialization.Attributes;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.FormDataServices
{
    //[BsonIgnoreExtraElements]
    public class DataSourceKeysOutputModel
    {
       // [BsonId]
        public Guid? Id { get; set; }
        public Guid? DataSourceId { get; set; }
        public Guid? GenericFormId { get; set; }
        public string Key { get; set; }
        public string Label { get; set; }
        public string Type { get; set; }
        public bool? IsArchived { get; set; }
        public string FormName { get; set; }

        public int? DecimalLimit { get; set; }
        public DataServiceConversionModel Fields { get; set; }
        public string Format { get; set; }
        public bool? Delimiter { get; set; }
        public bool? RequireDecimal { get; set; }
        public string Path { get; set; }
        public PropertiesModel Properties { get; set; }
    }

    public class PropertiesModel
    {
        public Guid? ReferenceTypeId { get; set; }
        public string ReferenceTypeName { get; set; }
    }
    

    public class DataSourceKeysConfigurationOutputModel
    {
        public Guid? Id { get; set; }
        public Guid? DataSourceId { get; set; }
        public Guid? DataSourceKeyId { get; set; }
        public Guid? CustomApplicationId { get; set; }
        public bool? IsDefault { get; set; }
        public bool? IsPrivate { get; set; }
        public bool? IsTag { get; set; }
        public bool? IsTrendsEnable { get; set; }
        public string Key { get; set; }
        public string Label { get; set; }
        public string FormName { get; set; }
        public string SelectedKeyIds { get; set; }
        public string SelectedPrivateKeyIds { get; set; }
        public string SelectedEnableTrendsKeys { get; set; }
        public string SelectedTagKeyIds { get; set; }
        public DataServiceConversionModel Fields { get; set; }
    }

    public class DataSourceKeysConfiguration
    {
        public List<DataSourceKeysConfigurationOutputModel> dataSourceKeys { get; set; }
        public string SelectedKeyIds { get; set; }
        public string SelectedPrivateKeyIds { get; set; }
        public string SelectedEnableTrendsKeys { get; set; }
        public string SelectedTagKeyIds { get; set; }
    }
    public class SearchAllDataSourcesOutpuutModel
    {
        public Guid? Id { get; set; }
        public string Name { get; set; }
    }
    public class GetFormFieldValuesInputModel
    {
        public Guid? FormId { get; set; }
        public string FormName { get; set; }
        public string Key { get; set; }
        public string CompanyIds { get; set; }
        public bool? FilterFieldsBasedOnForm { get; set; }
        public string FilterFormName { get; set; }
        public int? PageNumber { get; set; }
        public int? PageSize { get; set; }
        public bool? IsPagingRequired { get; set; }
        public string FilterValue { get; set; }
        public string Value { get; set; }
    }
}
