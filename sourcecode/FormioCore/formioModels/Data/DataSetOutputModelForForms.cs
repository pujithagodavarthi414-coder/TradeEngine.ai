using MongoDB.Bson.Serialization.Attributes;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace formioModels.Data
{
    [BsonIgnoreExtraElements]
    public class DataSetOutputModelForForms
    {
        [BsonId]
        public Guid? Id { get; set; }
        public Guid? DataSourceId { get; set; }
        public object DataJson { get; set; }
        public string DataSourceName { get; set; }
        public string DataSourceType { get; set; }
        public bool? IsArchived { get; set; }
        public bool? IsPdfGenerated { get; set; }
        public object DataSourceFormJson { get; set; }
        public DateTime CreatedDateTime { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public Guid? UpdatedByUserId { get; set; }
        public int? TotalCount { get; set; }
       
    }
}
