using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.MasterData
{
    public class RateSheetSearchCriteriaInputModel : SearchCriteriaInputModelBase
    {
        public RateSheetSearchCriteriaInputModel() : base(InputTypeGuidConstants.GetRateSheet)
        {
        }
        public Guid? RateSheetId { get; set; }
        public string RateSheetName { get; set; }
        public Guid? RateSheetForId { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(" RateSheetId = " + RateSheetId);
            stringBuilder.Append(", RateSheetName = " + RateSheetName);
            stringBuilder.Append(", RateSheetForId = " + RateSheetForId);
            return stringBuilder.ToString();
        }
    }
}
