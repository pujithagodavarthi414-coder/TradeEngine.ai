using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.DocumentManagement
{
    public class StoreInputModel : InputModelBase
    {
        public StoreInputModel() : base(InputTypeGuidConstants.StoreInputCommandTypeGuid)
        {
        }

        public Guid? StoreId { get; set; }
        public string StoreName { get; set; }
        public bool IsDefault { get; set; }
        public bool IsArchived { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("StoreId = " + StoreId);
            stringBuilder.Append("StoreName = " + StoreName);
            stringBuilder.Append("IsDefault = " + IsDefault);
            stringBuilder.Append("IsArchived = " + IsArchived);
            stringBuilder.Append("TimeStamp = " + TimeStamp);
            return stringBuilder.ToString();
        }
    }
}
