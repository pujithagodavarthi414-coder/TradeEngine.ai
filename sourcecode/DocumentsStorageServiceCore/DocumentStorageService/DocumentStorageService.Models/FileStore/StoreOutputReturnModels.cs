using MongoDB.Bson.Serialization.Attributes;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DocumentStorageService.Models.FileStore
{
    [BsonIgnoreExtraElements]
    public class StoreOutputReturnModels
    {
        [BsonId]
        public Guid? Id { get; set; }
        //public Guid? StoreId { get; set; }
        public string StoreName { get; set; }
        public bool? IsDefault { get; set; }
        public bool? IsSystemLevel { get; set; }
        public bool? IsCompany { get; set; }
        public bool IsArchived { get; set; }
        public int TotalCount { get; set; }
        public long? StoreSize { get; set; }
        public long? StoreCount { get; set; }
        public byte[] TimeStamp { get; set; }
        public Guid? CompanyId { get; set; }
    }
}
