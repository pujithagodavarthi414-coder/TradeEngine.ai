using System;
using System.Text;

namespace Btrak.Models.StatusReportingConfiguration
{
    public class SpentTimeReasonModel
    {
        public Guid UserSpentTimeReasonId { get; set; }

        public String Comment { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("UserSpentTimeReasonId = " + UserSpentTimeReasonId);
            stringBuilder.Append(", Comment = " + UserSpentTimeReasonId);
            return stringBuilder.ToString();
        }
    }
}