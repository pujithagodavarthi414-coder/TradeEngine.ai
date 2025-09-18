using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.MasterData
{
    public class RateSheetForSearchCriteriaInputModel : SearchCriteriaInputModelBase
    {
        public RateSheetForSearchCriteriaInputModel() : base(InputTypeGuidConstants.GetRateSheetFor)
        {
        }
        public Guid? RateSheetForId { get; set; }
        public Guid? RateSheetForName { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(" RateSheetForId = " + RateSheetForId);
            stringBuilder.Append(", RateSheetForName = " + RateSheetForName);
            return stringBuilder.ToString();
        }
    }
}
