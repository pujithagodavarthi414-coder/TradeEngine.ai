using MongoDB.Bson.Serialization.Attributes;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace formioModels.Data
{
    [BsonIgnoreExtraElements]
    public class GetDataSourcesByIdOutputModel
    {
        public Guid? Id { get; set; }
        public string Name { get; set; }
        public List<KeysModel> KeySet { get; set; }
    }

    public class KeysModel
    {
        public Guid? Id { get; set; }
        public string Key { get; set; }
        public string Label { get; set; }
        public string Type { get; set; }
        public string Path { get; set; }
    }

    public class SearchDataSourceOutputModel
    {
        public Guid? Id { get; set; }
        public string Name { get; set; }

    }

    public class GetDataSourcesByIdInputModel
    {
        public string FormIds { get; set; }
        public string CompanyIds { get; set; }
        public bool IsArchived { get; set; }

    }

    public class SearchDataSourceInputModel
    {
        public Guid? FormId { get; set; }
        public string KeyName { get; set; }
        public string FormIds { get; set; }

    }

    public class GetFormFieldValuesInputModel
    {
        public Guid? FormId { get; set; }
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
    public class GetFormFieldValuesOutputModel
    {
        public string Key { get; set; }
        public string Type { get; set; }
        public int? DecimalLimit { get; set; }
        public string Format { get; set; }
        public bool? Delimiter { get; set; }
        public bool? RequireDecimal { get; set; }
        public object FieldValues { get; set; }
    }
    public class SampleOutputModel
    {
        public Guid? Id { get; set; }
        public string Key { get; set; }
        public string Type { get; set; }
        public int? DecimalLimit { get; set; }
        public string Format { get; set; }
        public bool? Delimiter { get; set; }
        public bool? RequireDecimal { get; set; }
    }

    public class InnerOutputModel
    {
        public dynamic Data { get; set; }
    }
    public class GetFormRecordValuesInputModel
    {
        public string KeyName { get; set; }
        public string KeyValue { get; set; }
        public string CompanyIds { get; set; }
        public List<FormsMiniModel> FormsModel { get; set; }
        public bool? IsForRq { get; set; }
    }
    public class FormsMiniModel
    {
        public string FormName { get; set; }
        public string KeyName { get; set; }
        public string KeyType { get; set; }
        public string Jsons { get; set; }
        public Guid? Id { get; set; }
        public Guid? FormId { get; set; }
        public DateTime? CreatedAt { get; set; }
        public string Format { get; set; }
        public bool? Delimiter { get; set; }
        public bool? RequireDecimal { get; set; }
        public int? DecimalLimit { get; set; }
        public string Path { get; set; }
    }

    public class FormsMiniModelForUpdate : FormsMiniModel
    {
        public object keyValue { get; set; }
    }

    public class LookupLinkModel
    {
        public Guid CustomApplicationId { get; set; }
        public Guid FormId { get; set; }
        public string CompanyIds { get; set; }
    }
}
