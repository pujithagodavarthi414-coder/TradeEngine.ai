using MongoDB.Bson.Serialization.Attributes;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using DocumentStorageService.Models.AccessRights;

namespace DocumentStorageService.Models.FileStore
{
    [BsonIgnoreExtraElements]
    public class FileApiReturnModel
    {
        [BsonId]
        public Guid? Id { get; set; }
        public Guid? FileId { get; set; }
        public string FileName { get; set; }
        public string Description { get; set; }
        public string FileExtension { get; set; }
        public string FilePath { get; set; }
        public long? FileSize { get; set; }
        public Guid? FolderId { get; set; }
        public Guid? StoreId { get; set; }
        public Guid? ReferenceId { get; set; }
        public Guid? ReferenceTypeId { get; set; }
        public string ReferenceTypeName { get; set; }
        public bool? IsArchived { get; set; }
        public DateTime CreatedDateTime { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public byte[] TimeStamp { get; set; }
        public bool? IsDefault { get; set; }
        public Guid? ReviewedByUserId { get; set; }
        public string ReviewedByUserName { get; set; }
        public DateTime? ReviewedDateTime { get; set; }
        public bool? IsToBeReviewed { get; set; }
        public List<VersionModel> Versions { get; set; }
        public Guid? DocumentId { get; set; }
        public int? VersionNumber { get; set; }
        public List<AccessModel> AccessRights { get; set; }


    }
}
