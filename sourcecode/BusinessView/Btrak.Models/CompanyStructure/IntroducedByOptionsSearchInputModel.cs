using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.CompanyStructure
{
    public class IntroducedByOptionsSearchInputModel : SearchCriteriaInputModelBase
    {
        public IntroducedByOptionsSearchInputModel() : base(InputTypeGuidConstants.IntroducedByOptionsSearchInput)
        {
        }

        public Guid? CompanyIntroducedByOptionId { get; set; }
        public string Option { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", CompanyIntroducedByOptionId   = " + CompanyIntroducedByOptionId);
            stringBuilder.Append(", Option  = " + Option);
            return stringBuilder.ToString();
        }
    }
}
