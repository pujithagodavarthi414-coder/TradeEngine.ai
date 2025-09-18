using MongoDB.Bson.Serialization.Attributes;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using DocumentStorageService.Models.AccessRights;

namespace DocumentStorageService.Models.FileStore
{
   public class FileCollectionModel
    {
        public Guid? FolderId { get; set; }
        public Guid? StoreId { get; set; }
        public Guid? ReferenceId { get; set; }
        public Guid? ReferenceTypeId { get; set; }
        public string ReferenceTypeName { get; set; }
        public int FileType { get; set; }
       
        public bool? IsToBeReviewed { get; set; }
        public Guid? FileId { get; set; }
        public string FileName { get; set; }
        public long? FileSize { get; set; }
        public string FilePath { get; set; }
        public string Description { get; set; }
        public string FileExtension { get; set; }
        public bool? IsArchived { get; set; }
        public bool? IsQuestionDocuments { get; set; }
        public Guid? QuestionDocumentId { get; set; }
        [BsonElement]
        [BsonDateTimeOptions(Kind = DateTimeKind.Utc)]
        public DateTime? CreatedDateTime { get; set; }
        public Guid? CreatedByUserId { get; set; }
        [BsonElement]
        [BsonDateTimeOptions(Kind = DateTimeKind.Utc)]
        public DateTime? UpdatedDateTime { get; set; }
        public Guid? UpdatedByUserId { get; set; }
        public Guid? Id { get; set; }
        public Guid? ReviewedByUserId { get; set; }
        [BsonElement]
        [BsonDateTimeOptions(Kind = DateTimeKind.Utc)]
        public DateTime? ReviewedDateTime { get; set; }
        public List<VersionModel> Versions { get; set; }
        public List<AccessModel> AccessRights { get; set; }
        public int? VersionNumber { get; set; }
        public Guid? DocumentId { get; set; }
    }
}
