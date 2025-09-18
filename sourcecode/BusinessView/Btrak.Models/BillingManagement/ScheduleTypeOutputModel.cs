using System;
using System.Text;

namespace Btrak.Models.BillingManagement
{
    public class ScheduleTypeOutputModel
    {
        public Guid? ScheduleTypeId { get; set; }
        public string ScheduleType { get; set; }
        public int TotalCount { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("ScheduleTypeId" + ScheduleTypeId);
            stringBuilder.Append("ScheduleType" + ScheduleType);
            stringBuilder.Append("TotalCount" + TotalCount);
            return base.ToString();
        }
    }
}
