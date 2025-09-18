using formioModels.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace formioModels
{
    public class FieldUpdateWorkFlowModel
    {
        public Guid? DataSetId { get; set; }
        public string FieldUpdateModelJson { get; set; }
        public List<FieldUpdateModel> FieldUpdateModel { get; set; }
        public string FieldUniqueId { get; set; }  
    }
    public class FieldUpdateModel
    {
        public string FormName { get; set; }
        public string FieldName { get; set; }
        public string FieldValue { get; set; }
        public Guid? FormId { get; set; }
        public Guid? SyncForm { get; set; }
    }
    public class FormKeysModel
    {
        public Guid? Id { get; set; }
        public string Key { get; set; }
        public string Type { get; set; }
        public string Path { get; set; }
    }

    public class SyncFormModel
    {
        public Guid Id { get; set; }
    }
    public class UpdateDataSetWorkFlowModel
    {
        public DataSetInputModel DataSetUpsertInputModel { get; set; }
        public Guid? DataSetId { get; set; }
        public Guid? DataSourceId { get; set; }
        public Guid? NewRecordDataSetId { get; set; }
        public Guid? NewRecordDataSourceId { get; set; }
        public Dictionary<string, string> KeyValueList { get; set; }
    }
}
