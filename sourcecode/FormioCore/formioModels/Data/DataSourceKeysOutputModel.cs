using MongoDB.Bson.Serialization.Attributes;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace formioModels.Data
{
    [BsonIgnoreExtraElements]
    public class DataSourceKeysOutputModel
    {
        [BsonId]
        public Guid? Id { get; set; }
        public Guid? DataSourceId { get; set; }
        public string Key { get; set; }
        public string Label { get; set; }
        public bool? IsDefault { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public Guid? UpdatedByUserId { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public DateTime? UpdatedDateTime { get; set; }
        public DateTime? ArchivedDateTime { get; set; }
        public Guid? ArchivedByUserId { get; set; }
        public bool? IsArchived { get; set; }
        public string Type { get; set; }
        public string[] UserView { get; set; }
        public string[] UserEdit { get; set; }
        public string[] RoleView { get; set; }
        public string[] RoleEdit { get; set; }
        public string[] RelatedFieldsLabel { get; set; }
        public string GenricFormName { get; set; }
        public string FormName { get; set; }
        public string[] Relatedfield { get; set; }
        public string FieldName { get; set; }
        public string SelectedFormName { get; set; }
        public object RelatedFieldsfinalData { get; set; }
        public string ConcatSplitKey { get; set; }
        public string[] ConcateFormFields { get; set; }
        public string DateTimeForLinkedFields { get; set; }
        public string Format { get; set; }
        public int? DecimalLimit { get; set; }
        public Object Fields { get; set; }
        public bool? Delimiter { get; set; }
        public bool? RequireDecimal { get; set; }
        public string Path { get; set; }
        public string SelectedForm { get; set; }
        public string ValueSelection { get; set; }
        public string CalculateValue { get; set; }
        public PropertiesModel Properties { get; set; }
    }
    public class DataSourceKeysConfigOutputModel
    {
        [BsonId]
        public Guid? Id { get; set; }
        public Guid? DataSourceId { get; set; }
        public string Key { get; set; }
        public string Label { get; set; }
        public bool? IsDefault { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public Guid? UpdatedByUserId { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public DateTime? UpdatedDateTime { get; set; }
        public DateTime? ArchivedDateTime { get; set; }
        public Guid? ArchivedByUserId { get; set; }
        public bool? IsArchived { get; set; }
        public string Type { get; set; }
        public string[] UserView { get; set; }
        public string[] UserEdit { get; set; }
        public string[] RoleView { get; set; }
        public string[] RoleEdit { get; set; }
        public string[] RelatedFieldsLabel { get; set; }
        public string GenricFormName { get; set; }
        public string FormName { get; set; }
        public string[] Relatedfield { get; set; }
        public string FieldName { get; set; }
        public string SelectedFormName { get; set; }
        public object RelatedFieldsfinalData { get; set; }
        public string ConcatSplitKey { get; set; }
        public string[] ConcateFormFields { get; set; }
        public string DateTimeForLinkedFields { get; set; }
        public string Format { get; set; }
        public int? DecimalLimit { get; set; }
        public Object Fields { get; set; }
        public bool? Delimiter { get; set; }
        public bool? RequireDecimal { get; set; }
        public string Path { get; set; }
        public dynamic DataSourceKeysConfig { get; set; }
    }
}
