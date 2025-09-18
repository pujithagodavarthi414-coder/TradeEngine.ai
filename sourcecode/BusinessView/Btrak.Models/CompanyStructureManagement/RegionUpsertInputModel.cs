using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.CompanyStructureManagement
{
    public class RegionUpsertInputModel : InputModelBase
    {
        public RegionUpsertInputModel() : base(InputTypeGuidConstants.RegionUpsertInputCommandTypeGuid)
        {
        }

        public Guid? RegionId { get; set; }
        public string RegionName { get; set; }
        public Guid? CountryId { get; set; }
        public bool IsArchived { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("RegionId = " + RegionId);
            stringBuilder.Append(", RegionName = " + RegionName);
            stringBuilder.Append(", CountryId = " + CountryId);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}
