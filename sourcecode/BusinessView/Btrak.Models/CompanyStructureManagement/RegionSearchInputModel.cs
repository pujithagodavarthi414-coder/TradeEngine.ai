using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.CompanyStructureManagement
{
    public class RegionSearchInputModel : InputModelBase
    {
        public RegionSearchInputModel() : base(InputTypeGuidConstants.RegionSearchInputCommandTypeGuid)
        {
        }

        public Guid? RegionId { get; set; }
        public Guid? CountryId { get; set; }
        public string SearchText { get; set; }
        public bool? IsArchived { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("RegionId = " + RegionId);
            stringBuilder.Append(", CountryId  = " + CountryId);
            stringBuilder.Append(", SearchText  = " + SearchText);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}
