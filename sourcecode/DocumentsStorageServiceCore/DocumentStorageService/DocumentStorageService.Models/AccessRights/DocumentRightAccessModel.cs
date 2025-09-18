using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using MongoDB.Bson.Serialization.Attributes;

namespace DocumentStorageService.Models.AccessRights
{
    public class DocumentRightAccessModel
    {
        [BsonId]
        public Guid? Id { get; set; }
        public Guid? DocumentId { get; set; }
        public List<Guid?> UserIds { get; set; }
        public List<Guid?> RoleIds { get; set; }
        public Guid? RoleId { get; set; }
        public Guid? UserId { get; set; }
        public Guid? AccessId { get; set; }
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

        public class CreatedDocumentModel
        {
            public Guid? RoleId { get; set; }
            public Guid? AccessId { get; set; }
        }
        public class EditedDocumentModel
        {
            public Guid? UserId { get; set; }
            public Guid? AccessId { get; set; }
        }
    }
}
