using System;
using System.Text;

namespace Btrak.Models.DocumentManagement
{
    public class StoreConfigurationOutputModel
    {
        public string FileExtensions { get; set; }
        public long MaxFileSize { get; set; }
        public long MaxStoreSize { get; set; }
        public Guid UserId { get; set; }


        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("FileExtensions = " + FileExtensions);
            stringBuilder.Append(", MaxFileSize = " + MaxFileSize);
            stringBuilder.Append(", MaxStoreSize = " + MaxStoreSize);
            stringBuilder.Append(", UserId = " + UserId);
            return stringBuilder.ToString();
        }
    }
}
