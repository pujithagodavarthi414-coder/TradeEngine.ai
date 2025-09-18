using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.DocumentManagement
{
    public class StoreReturnModel
    {
        public Guid? StoreId { get; set; }
        public string StoreName { get; set; }
        public bool? IsDefault { get; set; }
        public bool? IsSystemLevel { get; set; }
        public bool? IsCompany { get; set; }
        public bool IsArchived { get; set; }
        public int TotalCount { get; set; }
        public long? StoreSize { get; set; }
        public int? StoreCount { get; set; }
        public byte[] TimeStamp { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("StoreId = " + StoreId);
            stringBuilder.Append(", StoreName = " + StoreName);
            stringBuilder.Append(", IsDefault = " + IsDefault);
            stringBuilder.Append(", IsCompany = " + IsCompany);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", TotalCount = " + TotalCount);
            stringBuilder.Append(", StoreSize = " + StoreSize);
            stringBuilder.Append(", StoreCount = " + StoreCount);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            return stringBuilder.ToString();
        }
    }
}
