using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.MasterData
{
    public class SpecificDaySearchCriteriaInputModel : SearchCriteriaInputModelBase
    {
        public SpecificDaySearchCriteriaInputModel() : base(InputTypeGuidConstants.SpecificDaySearchCriteriaInputCommandTypeGuid)
        {
        }
        public Guid? SpecificDayId { get; set; }
       
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("SpecificDayId = " + SpecificDayId);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", SearchText = " + SearchText);
            return stringBuilder.ToString();
        }
    }
}
