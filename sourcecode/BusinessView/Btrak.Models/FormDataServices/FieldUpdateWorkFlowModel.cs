using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.FormDataServices
{
    public class FieldUpdateWorkFlowModel
    {
        public Guid? DataSetId { get; set; }
        public string FieldUpdateModelJson { get; set; }
        public string FieldUniqueId { get; set; }
        public string MongoBaseURL { get; set; }
    }
    public class UpdateDataSetWorkflowModel
    {
        public DataSetUpsertInputModel DataSetUpsertInputModel { get; set; }
        public Guid? DataSetId { get; set; }
        public Guid? DataSourceId {  get; set; }
        public Guid? NewRecordDataSetId { get; set; }
        public Guid? NewRecordDataSourceId { get; set; }
        public string MongoBaseURL { get; set; }
        public Dictionary<string, string> KeyValueList { get; set; }
      
    }
    public class RecordCreationWorkflowModel
    {
        public Guid? DataSourceId { get; set; }
        public Guid? CustomApplicationId { get; set; }
        public string DataJsonKeys { get; set; }
        public bool? IsFileUpload { get; set; }
        public string FileUploadKey { get; set; }
    }
}
