using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.MasterData
{
    public class CompanyIntroducedByOptionInputModel : InputModelBase
    {
        public CompanyIntroducedByOptionInputModel() : base(InputTypeGuidConstants.CompanyIntroducedByOptionInputCommandTypeGuid)
        {
        }
       
        public Guid? CompanyIntroducedByOptionId { get; set; }
        public string Option { get; set; }
        public bool IsArchived { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("IntroducedByOptionId = " + CompanyIntroducedByOptionId);
            stringBuilder.Append(", Option = " + Option);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}