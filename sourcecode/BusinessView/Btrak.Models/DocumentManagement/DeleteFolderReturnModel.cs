using System;
using System.Text;

namespace Btrak.Models.File
{
    public class DeleteFolderReturnModel
    {
        public Guid? FolderId { get; set; }
        public Guid? StoreId { get; set; }
        public long? FolderSize { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("FolderId = " + FolderId);
            stringBuilder.Append(", StoreId = " + StoreId);
            stringBuilder.Append(", FolderSize = " + FolderSize);
            return stringBuilder.ToString();
        }
    }
}
