using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.PayRoll
{
    public class BankUpsertInputModel : InputModelBase
    {
        public BankUpsertInputModel() : base(InputTypeGuidConstants.BankInputCommandTypeGuid)
        {
        }

        public Guid? BankId { get; set; }
        public Guid? CountryId { get; set; }
        public string BankName { get; set; }
        public bool? IsArchived { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("BankId = " + BankId);
            stringBuilder.Append(",CountryId = " + CountryId);
            stringBuilder.Append(",BankName = " + BankName);
            stringBuilder.Append(",IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}
