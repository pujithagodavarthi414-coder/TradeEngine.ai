using MongoDB.Bson.Serialization.Attributes;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DocumentStorageService.Models.FileStore
{
    public class StoreCollectionModel
    {
        [BsonId]
        public Guid? Id { get; set; }
        public string StoreName { get; set; }
        public long? StoreSize { get; set; }
        public Guid? CompanyId { get; set; }
        public bool? IsDefault { get; set; }
        public bool? IsArchived { get; set; }
        [BsonElement]
        [BsonDateTimeOptions(Kind = DateTimeKind.Utc)]
        public DateTime? CreatedDateTime { get; set; }
        public Guid? CreatedByUserId { get; set; }
        [BsonElement]
        [BsonDateTimeOptions(Kind = DateTimeKind.Utc)]
        public DateTime? UpdatedDateTime { get; set; }
        public Guid? UpdatedByUserId { get; set; }
        public bool? IsCompany { get; set; }
    }
}
