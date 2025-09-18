using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.MasterData
{
    public class PeakHourSearchCriteriaInputModel : SearchCriteriaInputModelBase
    {
        public PeakHourSearchCriteriaInputModel() : base(InputTypeGuidConstants.GetPeakHour)
        {
        }
        public Guid? PeakHourId { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(" PeakHourId = " + PeakHourId);
            return stringBuilder.ToString();
        }
    }
}
