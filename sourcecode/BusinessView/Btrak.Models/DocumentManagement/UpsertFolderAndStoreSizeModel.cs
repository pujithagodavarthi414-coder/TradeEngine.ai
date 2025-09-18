using System;
using System.Text;

namespace Btrak.Models.File
{
    public class UpsertFolderAndStoreSizeModel
    {
        public Guid? FolderId { get; set; }
        public Guid? StoreId { get; set; }
        public long? Size { get; set; }
        public bool IsDeletion { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(" FolderId = " + FolderId);
            stringBuilder.Append(", StoreId = " + StoreId);
            stringBuilder.Append(", Size = " + Size);
            stringBuilder.Append(", IsDeletion = " + IsDeletion);
            return stringBuilder.ToString();
        }
    }
}