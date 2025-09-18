using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.File
{
    public class UpsertFolderInputModel : InputModelBase
    {
        public UpsertFolderInputModel() : base(InputTypeGuidConstants.UpsertFolderInputCommandTypeGuid)
        {
        }

        public Guid? FolderId { get; set; }
        public string FolderName { get; set; }
        public string Description { get; set; }
        public Guid? ParentFolderId { get; set; }
        public Guid? StoreId { get; set; }
        public Guid? FolderReferenceId { get; set; }
        public Guid? FolderReferenceTypeId { get; set; }
        public bool? IsArchived { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", FolderId = " + FolderId);
            stringBuilder.Append(", FolderName = " + FolderName);
            stringBuilder.Append(", Description = " + Description);
            stringBuilder.Append(", ParentFolderId = " + ParentFolderId);
            stringBuilder.Append(", StoreId = " + StoreId);
            stringBuilder.Append(", FolderReferenceId = " + FolderReferenceId);
            stringBuilder.Append(", FolderReferenceTypeId = " + FolderReferenceTypeId);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}