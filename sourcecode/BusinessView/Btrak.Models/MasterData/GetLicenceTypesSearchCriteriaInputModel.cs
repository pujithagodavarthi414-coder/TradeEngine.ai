using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.MasterData
{
    public class GetLicenceTypesSearchCriteriaInputModel : SearchCriteriaInputModelBase
    {
        public GetLicenceTypesSearchCriteriaInputModel() : base(InputTypeGuidConstants.GetLicenceTypes)
        {
        }
        public Guid? LicenceTypeId { get; set; }
        public string LicenceTypeName { get; set; }
        
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(" LicenceTypeId = " + LicenceTypeId);
            stringBuilder.Append(" LicenceTypeName = " + LicenceTypeName);
            return stringBuilder.ToString();
        }
    }
}
