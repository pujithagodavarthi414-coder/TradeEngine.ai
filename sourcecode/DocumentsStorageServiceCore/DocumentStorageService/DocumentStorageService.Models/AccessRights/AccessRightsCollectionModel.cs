using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using MongoDB.Bson.Serialization.Attributes;

namespace DocumentStorageService.Models.AccessRights
{
    public class AccessRightsCollectionModel
    {
        [BsonId]
        public Guid? Id { get; set; }
        public Guid? UserId { get; set; }
        public Guid? RoleId { get; set; }
        public Guid? DocumentId { get; set; }
        public bool? IsEditAccess { get; set; }
        public bool? IsCreateAccess { get; set; }
        public bool? IsViewAccess { get; set; }
        [BsonElement]
        [BsonDateTimeOptions(Kind = DateTimeKind.Utc)]
        public DateTime? CreatedDateTime { get; set; }
        public Guid? CreatedByUserId { get; set; }
        [BsonElement]
        [BsonDateTimeOptions(Kind = DateTimeKind.Utc)]
        public DateTime? UpdatedDateTime { get; set; }
        public Guid? UpdatedByUserId { get; set; }
        public Guid? ArchivedByUserId { get; set; }
        [BsonElement]
        [BsonDateTimeOptions(Kind = DateTimeKind.Utc)]
        public DateTime? ArchivedDateTime { get; set; }
        public bool? IsArchived { get; set; }  
        public Guid? AccessId { get; set; }

    }
}
