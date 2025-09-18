using System;
using System.Collections.Generic;
using MongoDB.Bson.Serialization.Attributes;

namespace formioModels.Data
{
    [BsonIgnoreExtraElements]
    public class DataSourceOutputModel
    {
        public Guid? Id { get; set; }
        public Guid Key { get; set; }
        public Guid? FormTypeId { get; set; }
        public string Description { get; set; }
        public string Name { get; set; }
        public string FormBgColor { get; set; }
        public string DataSourceType { get; set; }
        public string Tags { get; set; }
        public object Fields { get; set; }
        public bool IsArchived { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public Guid? DataSetId { get; set; }
        public object DataSetFormJson { get; set; }
        public Guid[] ViewFormRoleIds { get; set; }
        public Guid[] EditFormRoleIds { get; set; }
    }
}
