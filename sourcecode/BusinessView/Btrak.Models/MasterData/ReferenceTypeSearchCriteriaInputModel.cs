using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.MasterData
{
    public class ReferenceTypeSearchCriteriaInputModel : SearchCriteriaInputModelBase
    {
        public ReferenceTypeSearchCriteriaInputModel() : base(InputTypeGuidConstants.ReferenceTypeSearchCriteriaInputCommandTypeGuid)
        {
        }

        public Guid? ReferenceTypeId { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("ReferenceTypeId = " + ReferenceTypeId);
            stringBuilder.Append(", SearchText   = " + SearchText);
            return stringBuilder.ToString();
        }
    }
}
