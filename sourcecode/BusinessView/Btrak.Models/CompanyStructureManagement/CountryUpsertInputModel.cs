using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.CompanyStructureManagement
{
    public class CountryUpsertInputModel : InputModelBase
    {
        public CountryUpsertInputModel() : base(InputTypeGuidConstants.CountryUpsertInputCommandTypeGuid)
        {
        }

        public Guid? CountryId { get; set; }
        public string CountryName { get; set; }
        public string CountryCode { get; set; }
        public bool IsArchived { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("CountryId = " + CountryId);
            stringBuilder.Append(", CountryName = " + CountryName);
            stringBuilder.Append(", CountryCode = " + CountryCode);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}
