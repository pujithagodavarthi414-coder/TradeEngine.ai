using MongoDB.Bson.Serialization.Attributes;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DocumentStorageService.Models.FileStore
{
    public class FolderCollectionModel
    {
        [BsonId]
        public Guid? Id { get; set; }
        public string FolderName { get; set; }
        public string Description { get; set; }
        public Guid? ParentFolderId { get; set; }
        public Guid? StoreId { get; set; }
        public Guid? FolderReferenceId { get; set; }
        public Guid? FolderReferenceTypeId { get; set; }
        public bool? IsArchived { get; set; }
        [BsonElement]
        [BsonDateTimeOptions(Kind = DateTimeKind.Utc)]
        public DateTime? CreatedDateTime { get; set; }
        public Guid? CreatedByUserId { get; set; }
        [BsonElement]
        [BsonDateTimeOptions(Kind = DateTimeKind.Utc)]
        public DateTime? InActiveDateTime { get; set; }
        [BsonElement]
        [BsonDateTimeOptions(Kind = DateTimeKind.Utc)]
        public DateTime? UpdatedDateTime { get; set; }
        public Guid? UpdatedByUserId { get; set; }
        public long? FolderSize { get; set; }
        
    }
}
