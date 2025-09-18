using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.Expenses
{
    public class MerchantModel : InputModelBase
    {
        public MerchantModel() : base(InputTypeGuidConstants.UpsertMerchantInputCommandTypeGuid)
        {
        }

        public Guid? MerchantId { get; set; }
        public string MerchantName { get; set; }
        public string Description { get; set; }
        public bool? IsArchived { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("Id = " + MerchantId);
            stringBuilder.Append(", MerchantName = " + MerchantName);
            stringBuilder.Append(", Description = " + Description);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            return stringBuilder.ToString();
        }
    }
}
