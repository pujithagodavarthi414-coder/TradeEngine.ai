using System;
using System.Text;

namespace Btrak.Models.File
{
    public class FileApiReturnModel
    {
        public Guid? FileId { get; set; }
        public string FileName { get; set; }
        public string FileExtension { get; set; }
        public string FilePath { get; set; }
        public string Description { get; set; }
        public long? FileSize { get; set; }
        public Guid? FolderId { get; set; }
        public Guid? StoreId { get; set; }
        public Guid? ReferenceId { get; set; }
        public Guid? ReferenceTypeId { get; set; }
        public bool? IsArchived { get; set; }
        public DateTime CreatedDateTime { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public byte[] TimeStamp { get; set; }
        public bool? IsDefault { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("FileId = " + FileId);
            stringBuilder.Append("FileName = " + FileName);
            stringBuilder.Append("FileExtension = " + FileExtension);
            stringBuilder.Append("FilePath = " + FilePath);
            stringBuilder.Append("FileSize = " + FileSize);
            stringBuilder.Append("FolderId = " + FolderId);
            stringBuilder.Append("StoreId = " + StoreId);
            stringBuilder.Append("ReferenceId = " + ReferenceId);
            stringBuilder.Append("ReferenceTypeId = " + ReferenceTypeId);
            stringBuilder.Append("IsArchived = " + IsArchived);
            stringBuilder.Append("CreatedDateTime = " + CreatedDateTime);
            stringBuilder.Append("CreatedByUserId = " + CreatedByUserId);
            stringBuilder.Append("TimeStamp = " + TimeStamp);
            stringBuilder.Append("IsDefault = " + IsDefault);
            return stringBuilder.ToString();
        }
    }

    public class FolderApiReturnModel
    {
        public Guid? FolderId { get; set; }
        public Guid? ParentFolderId { get; set; }
        public Guid? StoreId { get; set; }
        public Guid? FolderReferenceId { get; set; }
        public Guid? FolderReferenceTypeId { get; set; }
        public bool? IsFromSprints { get; set; }
        public bool? IsTreeView { get; set; }
        public string Description { get; set; }
        public string FolderName { get; set; }
        public float FolderSize { get; set; }
        public bool? IsArchived { get; set; }
        public DateTime CreatedDateTime { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public byte[] TimeStamp { get; set; }
    }
}
