using System;
using System.Text;

namespace Btrak.Models.File
{
    public class DeleteFileReturnModel
    {
        public Guid? FileId { get; set; }
        public Guid? ReferenceId { get; set; }
        public Guid? FolderId { get; set; }
        public Guid? StoreId { get; set; }
        public long? FileSize { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("FileId = " + FileId);
            stringBuilder.Append(", FolderId = " + FolderId);
            stringBuilder.Append(", StoreId = " + StoreId);
            stringBuilder.Append(", FileSize = " + FileSize);
            return stringBuilder.ToString();
        }
    }
}