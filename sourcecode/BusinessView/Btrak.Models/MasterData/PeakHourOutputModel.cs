using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.MasterData
{
    public class PeakHourOutputModel
    {

        public Guid? PeakHourId { get; set; }
        public string PeakHourOn { get; set; }
        public string FilterType { get; set; }
        public TimeSpan PeakHourFrom { get; set; }
        public TimeSpan PeakHourTo { get; set; }
        public bool? IsArchived { get; set; }
        public bool? IsPeakHour { get; set; }
        public byte[] TimeStamp { get; set; }
        public Guid? CompanyId { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public int? TotalCount { get; set; }

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
            stringBuilder.Append(" TimeStamp = " + TimeStamp);
            stringBuilder.Append(" CompanyId = " + CompanyId);
            stringBuilder.Append(" CreatedDateTime = " + CreatedDateTime);
            stringBuilder.Append(" CreatedByUserId = " + CreatedByUserId);
            stringBuilder.Append(" TotalCount = " + TotalCount);
            return stringBuilder.ToString();
        }
    }
}
