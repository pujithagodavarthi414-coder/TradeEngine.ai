using System;
using System.Collections.Generic;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.File
{
    public class FileUpsertInputModel : InputModelBase
    {
        public FileUpsertInputModel() : base(InputTypeGuidConstants.FileUpsertInputCommandTypeGuid)
        {
        }
        
        public Guid? FolderId { get; set; }
        public Guid? StoreId { get; set; }
        public Guid? ReferenceId { get; set; }
        public Guid? ReferenceTypeId { get; set; }
        public Guid? FileTypeReferenceId { get; set; }
        public bool? IsFromFeedback { get; set; }
        public int FileType { get; set; }
        public string FilesXML { get; set; }
        public string Description { get; set; }
        public List<FileModel> FilesList { get; set; }
        public bool? IsToBeReviewed { get; set; }
        public bool? IsFileReUploaded { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(" FolderId = " + FolderId);
            stringBuilder.Append(" StoreId = " + StoreId);
            stringBuilder.Append(" ReferenceId = " + ReferenceId);
            stringBuilder.Append(" ReferenceTypeId = " + ReferenceTypeId);
            stringBuilder.Append(" FileType = " + FileType);
            stringBuilder.Append(" FilesList = " + FilesList);
            return stringBuilder.ToString();
        }
    }

    public class FileModel : InputModelBase
    {
        public FileModel() : base(InputTypeGuidConstants.FileUpsertInputCommandTypeGuid)
        {
        }

        public Guid? FileId { get; set; }
        public string FileName { get; set; }
        public long? FileSize { get; set; }
        public string FilePath { get; set; }
        public string FileExtension { get; set; }
        public bool? IsArchived { get; set; }
        public bool? IsQuestionDocuments { get; set; }
        public Guid? QuestionDocumentId { get; set; }
        public string Description { get; set; }
    }
}
