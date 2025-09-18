using MongoDB.Bson.Serialization.Attributes;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DocumentStorageService.Models.AccessRights
{
    public class AccessModel
    {
        [BsonId]
        public Guid? Id { get; set; }
        public Guid? UserId { get; set; }
        public Guid? RoleId { get; set; }
        public bool? IsViewAccess { get; set; }
        public bool? IsEditAccess { get; set; }
        public bool? IsCreateAccess { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public DateTime? UpdatedDateTime { get; set; }
        public Guid? UpdatedByUserId { get; set; }
        public DateTime? ArchivedDateTime { get; set; }
        public Guid? ArchivedByUserId { get; set; }
        public bool? IsArchived { get; set; }
    }
}
