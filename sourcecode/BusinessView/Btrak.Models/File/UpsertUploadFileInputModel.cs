using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.File
{
    public class UpsertUploadFileInputModel :InputModelBase
    {
        public UpsertUploadFileInputModel() : base(InputTypeGuidConstants.UpsertUploadFileInputCommandTypeGuid)
        {
        }
        public Guid? UploadFileId { get; set; }
        public string FileName { get; set; }
        public string FilePath { get; set; }
        public long? FileSize { get; set; }
        public Guid? ReferenceId { get; set; }
        public string ReferenceTypeName { get; set; }
        public Guid? ReferenceTypeId { get; set; }
        public Guid? FolderId { get; set; }
        public Guid? StoreId { get; set; }
        public bool? IsArchived { get; set; }
        public string FileExtension { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(" FolderId = " + FolderId);
            stringBuilder.Append(" StoreId = " + StoreId);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", UploadFileId = " + UploadFileId);
            stringBuilder.Append(", FileName= " + FileName);
            stringBuilder.Append(", FilePath= " + FilePath);
            stringBuilder.Append(", FileSize= " + FileSize);
            stringBuilder.Append(", ReferenceId= " + ReferenceId);
            stringBuilder.Append(", FileExtension= " + FileExtension);
            stringBuilder.Append(", ReferenceTypeName= " + ReferenceTypeName);
            return stringBuilder.ToString();

        }
    }
}