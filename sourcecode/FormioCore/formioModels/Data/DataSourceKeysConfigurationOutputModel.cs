using MongoDB.Bson.Serialization.Attributes;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace formioModels.Data
{
    [BsonIgnoreExtraElements]
    public class DataSourceKeysConfigurationOutputModel
    {
        [BsonId]
        public Guid? Id { get; set; }
        public Guid? DataSourceId { get; set; }
        public Guid? DataSourceKeyId { get; set; }
        public Guid? CustomApplicationId { get; set; }
        public bool? IsDefault { get; set; }
        public bool? IsPrivate { get; set; }
        public bool? IsTag { get; set; }
        public bool? IsTrendsEnable { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public Guid? UpdatedByUserId { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public DateTime? UpdatedDateTime { get; set; }
        public DateTime? ArchivedDateTime { get; set; }
        public Guid? ArchivedByUserId { get; set; }
        public bool? IsArchived { get; set; }
        public string Key { get; set; }
        public string Label { get; set; }
        public string FormName { get; set; }
        public object Fields { get; set; }

    }
}
