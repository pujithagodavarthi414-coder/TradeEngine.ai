using System;
using System.Text;

namespace Btrak.Models.BillingManagement
{
    public class AccountTypeModel
    {
        public Guid? AccountTypeId { get; set; }
        public string AccountTypeName { get; set; }
        public string SearchText { get; set; }
        public bool IsArchived { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public byte[] TimeStamp { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("AccountTypeId" + AccountTypeId);
            stringBuilder.Append("AccountTypeName" + AccountTypeName);
            stringBuilder.Append("SearchText" + SearchText);
            stringBuilder.Append("IsArchived" + IsArchived);
            stringBuilder.Append("TimeStamp" + TimeStamp);
            return base.ToString();
        }
    }
}