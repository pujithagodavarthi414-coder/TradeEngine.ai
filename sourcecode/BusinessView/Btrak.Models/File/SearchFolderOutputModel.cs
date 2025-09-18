using System;
using System.Text;

namespace Btrak.Models.File
{
    public class SearchFolderOutputModel
    {
        public string Folders { get; set; }
        public string Files { get; set; }
        public string BreadCrumb { get; set; }
        public string ParentFolderDescription { get; set; }
        public string Store { get; set; }
        public string FoldersAndFiles { get; set; }
        public string FolderName { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("  Folders = " + Folders);
            stringBuilder.Append("  Files = " + Files);
            stringBuilder.Append(", BreadCrumb = " + BreadCrumb);
            stringBuilder.Append(", ParentFolderDescription = " + ParentFolderDescription);
            stringBuilder.Append(", Store = " + Store);
            stringBuilder.Append(", FolderName = " + FolderName);
            return stringBuilder.ToString();
        }
        //public Guid? FolderId { get; set; }
        //public string FolderName { get; set; }
        //public Guid? ParentFolderId { get; set; }
        //public Guid? StoreId { get; set; }
        //public bool? IsArchived { get; set; }
        //public DateTime CreatedDateTime { get; set; }
        //public Guid? CreatedByUserId { get; set; }
        //public byte[] TimeStamp { get; set; }
        //public bool? IsDefault { get; set; }
        //public int? FolderCount { get; set; }
        //public long? FolderSize { get; set; }
        //public string BreadCrumb { get; set; }

        //public override string ToString()
        //{
        //    StringBuilder stringBuilder = new StringBuilder();
        //    stringBuilder.Append("  FolderId = " + FolderId);
        //    stringBuilder.Append(", FolderName = " + FolderName);
        //    stringBuilder.Append(", ParentFolderId = " + ParentFolderId);
        //    stringBuilder.Append(", StoreId = " + StoreId);
        //    stringBuilder.Append(", IsArchived = " + IsArchived);
        //    stringBuilder.Append(", CreatedDateTime = " + CreatedDateTime);
        //    stringBuilder.Append(", CreatedByUserId = " + CreatedByUserId);
        //    stringBuilder.Append(", TimeStamp = " + TimeStamp);
        //    stringBuilder.Append(", IsDefault = " + IsDefault);
        //    stringBuilder.Append(", FolderCount = " + FolderCount);
        //    stringBuilder.Append(", FolderSize = " + FolderSize);
        //    stringBuilder.Append(", BreadCrumb = " + BreadCrumb);
        //    return stringBuilder.ToString();
        //}
    }
}