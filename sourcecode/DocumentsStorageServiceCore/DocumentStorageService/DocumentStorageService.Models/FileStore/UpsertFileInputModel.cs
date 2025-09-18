using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DocumentStorageService.Models.FileStore
{
    public class UpsertFileInputModel
    {
        public Guid? FolderId { get; set; }
        public Guid? StoreId { get; set; }
        public Guid? ReferenceId { get; set; }
        public Guid? ReferenceTypeId { get; set; }
        public string ReferenceTypeName { get; set; }
        public Guid? FileTypeReferenceId { get; set; }
        public bool? IsFromFeedback { get; set; }
        public int FileType { get; set; }
        public string FilesXML { get; set; }
        public List<FileModel> FilesList { get; set; }
        public bool? IsToBeReviewed { get; set; }
        public string FolderName { get; set; }
        public List<string> ParentFolderNames { get; set; }
        public bool? IsArchived { get; set; }
        public List<UpsertFileInputModel> Versions { get; set; }
        public int? VersionNumber { get; set; }
        public Guid? DocumentId { get; set; }
    }

    public class FileModel
    {
        public Guid? FileId { get; set; }
        public string FileName { get; set; }
        public long? FileSize { get; set; }
        public string FilePath { get; set; }
        public string Description { get; set; }
        public string FileExtension { get; set; }
        public bool? IsArchived { get; set; }
        public bool? IsQuestionDocuments { get; set; }
        public Guid? QuestionDocumentId { get; set; }
        public byte[] TimeStamp { get; set; }
        public int? VersionNumber { get; set; }

    }

    public class VersionModel
    {
        public int? VersionNumber { get; set; }
        public string FilePath { get; set; }
    }

    public class ActivateAndArchiveFileInputModel
    {
        public List<FileModel> ActivateFile { get; set; }
        public List<Guid> ArchiveFileIds { get; set; }
    }
}
