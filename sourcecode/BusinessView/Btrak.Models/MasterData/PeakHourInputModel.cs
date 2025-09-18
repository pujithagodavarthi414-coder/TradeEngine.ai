using BTrak.Common;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.MasterData
{
    public class PeakHourInputModel : InputModelBase
    {

        public PeakHourInputModel() : base(InputTypeGuidConstants.GetPeakHour)
        {
        }

        public Guid? PeakHourId { get; set; }
        public string PeakHourOn { get; set; }
        public string FilterType { get; set; }
        public TimeSpan PeakHourFrom { get; set; }
        public TimeSpan PeakHourTo { get; set; }
        public bool? IsArchived { get; set; }
        public bool? IsPeakHour { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(" PeakHourId = " + PeakHourId);
            stringBuilder.Append(" PeakHourOn = " + PeakHourOn);
            stringBuilder.Append(" FilterType = " + FilterType);
            stringBuilder.Append(" PeakHourFrom = " + PeakHourFrom);
            stringBuilder.Append(" PeakHourTo = " + PeakHourTo);
            stringBuilder.Append(" IsPeakHour = " + IsPeakHour);
            stringBuilder.Append(" IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}
