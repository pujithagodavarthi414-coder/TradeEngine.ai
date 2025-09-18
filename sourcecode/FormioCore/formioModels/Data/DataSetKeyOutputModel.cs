using MongoDB.Bson.Serialization.Attributes;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace formioModels.Data
{
    [BsonIgnoreExtraElements]
    public class DataSetKeyOutputModel
    {
       
        [BsonId]
        public Guid? Id { get; set; }
        public string DataSourceName { get; set; }
        public string Key { get; set; }
        public object DataJson { get; set; }
    }
}
