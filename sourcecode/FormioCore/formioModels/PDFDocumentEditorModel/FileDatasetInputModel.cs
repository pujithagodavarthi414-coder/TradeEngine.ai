using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using MongoDB.Bson.Serialization.Attributes;
using MongoDB.Bson;
using PDFHTMLDesignerModels.PDFDocumentEditorModel;
using System.Text.Json.Serialization;

namespace PDFHTMLDesignerModels.DocumentModel.file
{
       
    [BsonIgnoreExtraElements]
    public class FileDatasetInputModel
    {
        public string UserId { get; set; }
        public string FolderId { get; set; }
        public string StoreId { get; set; }
        public string ReferenceId { get; set; }
        public string ReferenceTypeId { get; set; }
        public string ReferenceTypeName { get; set; }

        [BsonElement("SFDTFile")]
        [JsonPropertyName("SFDTFile")]
        public List<SFDTFile> SFDTFile { get; set; } = null!;

        [BsonElement("HTMLFile")]
        [JsonPropertyName("HTMLFile")]
        public List<HTMLFile> HTMLFile { get; set; } = null!;

        [BsonElement("PDFFile")]
        [JsonPropertyName("PDFFile")]
        public List<PDFFile> PDFFile { get; set; } = null!;

        [BsonElement("DOCFile")]
        [JsonPropertyName("DOCFile")]
        public List<DOCFile> DOCFile { get; set; } = null!;
        public Guid? CreatedByUserId { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public Guid? UpdatedByUserId { get; set; }
        public DateTime? UpdatedDateTime { get; set; }
        public Guid? ArchivedByUserId { get; set; }
        public DateTime? ArchivedDateTime { get; set; }
        public bool IsArchived { get; set; }
    }

    [BsonIgnoreExtraElements]
    public class HTMLFile
    {
        public string FileType { get; set; }
        public string FileId { get; set; }
        public string FileName { get; set; }
        public int FileSize { get; set; }
        public string FilePath { get; set; }
        public string Description { get; set; }
        public string FileExtension { get; set; }
        public Guid CreatedByUserId { get; set; }
        public DateTime CreatedDateTime { get; set; }
        public Guid? UpdatedByUserId { get; set; }
        public DateTime? UpdatedDateTime { get; set; }
        public Guid? ArchivedByUserId { get; set; }
        public DateTime? ArchivedDateTime { get; set; }
        public Guid? ReviewedByUserId { get; set; }
        public DateTime? ReviewedDateTime { get; set; }
        public List<object> Versions { get; set; }
        public List<object> AccessRights { get; set; }
        public int VersionNumber { get; set; }
        public string DocumentId { get; set; }
        public bool IsArchived { get; set; }
    }

    [BsonIgnoreExtraElements]
    public class PDFFile
    {
        public string FileType { get; set; }
        public string FileId { get; set; }
        public string FileName { get; set; }
        public int FileSize { get; set; }
        public string FilePath { get; set; }
        public string Description { get; set; }
        public string FileExtension { get; set; }
        public Guid CreatedByUserId { get; set; }
        public DateTime CreatedDateTime { get; set; }
        public Guid? UpdatedByUserId { get; set; }
        public DateTime? UpdatedDateTime { get; set; }
        public Guid? ArchivedByUserId { get; set; }
        public DateTime? ArchivedDateTime { get; set; }
        public Guid? ReviewedByUserId { get; set; }
        public DateTime? ReviewedDateTime { get; set; }
        public List<object> Versions { get; set; }
        public List<object> AccessRights { get; set; }
        public int VersionNumber { get; set; }
        public object DocumentId { get; set; }
        public bool IsArchived { get; set; }
    }

    [BsonIgnoreExtraElements]
    public class SFDTFile
    {
        public string FileType { get; set; }
        public object FileId { get; set; }
        public string FileName { get; set; }
        public int FileSize { get; set; }
        public string FilePath { get; set; }
        public object Description { get; set; }
        public string FileExtension { get; set; }
        public Guid CreatedByUserId { get; set; }
        public DateTime CreatedDateTime { get; set; }
        public Guid? UpdatedByUserId { get; set; }
        public DateTime? UpdatedDateTime { get; set; }
        public Guid? ArchivedByUserId { get; set; }
        public DateTime? ArchivedDateTime { get; set; }
        public Guid? ReviewedByUserId { get; set; }
        public DateTime? ReviewedDateTime { get; set; }
        public List<object> Versions { get; set; }
        public List<object> AccessRights { get; set; }
        public int VersionNumber { get; set; }
        public object DocumentId { get; set; }
        public bool IsArchived { get; set; }
    }

    [BsonIgnoreExtraElements]
    public class DOCFile
    {
        public string FileType { get; set; }
        public string FileId { get; set; }
        public string FileName { get; set; }
        public int FileSize { get; set; }
        public string FilePath { get; set; }
        public string Description { get; set; }
        public string FileExtension { get; set; }
        public Guid CreatedByUserId { get; set; }
        public DateTime CreatedDateTime { get; set; }
        public Guid? UpdatedByUserId { get; set; }
        public DateTime? UpdatedDateTime { get; set; }
        public Guid? ArchivedByUserId { get; set; }
        public DateTime? ArchivedDateTime { get; set; }
        public Guid? ReviewedByUserId { get; set; }
        public DateTime? ReviewedDateTime { get; set; }
        public List<object> Versions { get; set; }
        public List<object> AccessRights { get; set; }
        public int VersionNumber { get; set; }
        public string DocumentId { get; set; }
        public bool IsArchived { get; set; }
    }
}
