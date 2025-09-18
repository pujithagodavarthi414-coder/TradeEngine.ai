using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DocumentStorageService.Models.FileStore
{
    public class FileUpsertReturnModel
    {
        public Guid? FileId { get; set; }
        public Guid? FolderId { get; set; }
        public long? FileSize { get; set; }
        public Guid? StoreId { get; set; }
        public string FileName { get; set; }
        public string Description { get; set; }
        public string FileExtension { get; set; }
        public Guid? ReferenceTypeId { get; set; }
        public string ReferenceTypeName { get; set; }
        public bool? IsQuestionDocuments { get; set; }
        public Guid? QuestionDocumentId { get; set; }
        public bool? IsToBeReviewed { get; set; }
        public string FilePath { get; set; }
        public Guid? ReferenceId { get; set; }
        public bool? IsArchived { get; set; }
        public Guid? DocumentId { get; set; }
        public int? VersionNumber { get; set; }
        public List<FileUpsertReturnModel> Versions { get; set; }
    }
}
