using MongoDB.Bson.Serialization.Attributes;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DocumentStorageService.Models.FileStore
{
    [BsonIgnoreExtraElements]
    public class UploadFileReturnModel
    {
        [BsonId]
        public Guid? Id { get; set; }
        public string FileName { get; set; }
        public long? FileSize { get; set; }
        public string FileExtension { get; set; }
        public string FilePath { get; set; }
        public Guid? FolderId { get; set; }
        public Guid? ReferenceId { get; set; }
        public Guid? ReferenceTypeId { get; set; }
        public DateTimeOffset? InActiveDateTime { get; set; }
    }
}
