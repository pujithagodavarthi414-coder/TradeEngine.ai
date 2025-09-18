using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.BillingManagement
{
    public class ScheduleSequenceOutputModel
    {
        public Guid? ScheduleSequenceId { get; set; }
        public string ScheduleSequenceName { get; set; }
        public int TotalCount { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("ScheduleSequenceId" + ScheduleSequenceId);
            stringBuilder.Append("ScheduleSequenceName" + ScheduleSequenceName);
            stringBuilder.Append("TotalCount" + TotalCount);
            return base.ToString();
        }
    }
}
