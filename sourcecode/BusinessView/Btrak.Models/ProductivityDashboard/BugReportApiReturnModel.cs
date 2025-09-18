using System;
using System.Text;

namespace Btrak.Models.ProductivityDashboard
{
    public class BugReportApiReturnModel
    {
        public DateTime Date { get; set; }
        public Guid ParameterId { get; set; }
        public string ParameterName { get; set; }
        public int? P0Left { get; set; }
        public int? P1Left { get; set; }
        public int? P2Left { get; set; }
        public int? P3Left { get; set; }
        public int? P0Fixed { get; set; }
        public int? P1Fixed { get; set; }
        public int? P2Fixed { get; set; }
        public int? P3Fixed { get; set; }
        public int? P0Added { get; set; }
        public int? P1Added { get; set; }
        public int? P2Added { get; set; }
        public int? P3Added { get; set; }
        public int? P0Approved { get; set; }
        public int? P1Approved { get; set; }
        public int? P2Approved { get; set; }
        public int? P3Approved { get; set; }
        public int? P0UnAssigned { get; set; }
        public int? P1UnAssigned { get; set; }
        public int? NoPriorityAdded { get; set; }
        public int? P2UnAssigned { get; set; }
        public int? P3UnAssigned { get; set; }
        public int? NoPriority { get; set; }
        public int TotalCount { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("Date = " + Date);
            stringBuilder.Append(", ParameterId = " + ParameterId);
            stringBuilder.Append(", ParameterName = " + ParameterName);
            stringBuilder.Append(", P0Left = " + P0Left);
            stringBuilder.Append(", P1Left = " + P1Left);
            stringBuilder.Append(", P2Left = " + P2Left);
            stringBuilder.Append(", P3Left = " + P3Left);
            stringBuilder.Append(", P0Fixed = " + P0Fixed);
            stringBuilder.Append(", P1Fixed = " + P1Fixed);
            stringBuilder.Append(", P2Fixed = " + P2Fixed);
            stringBuilder.Append(", P3Fixed = " + P3Fixed);
            stringBuilder.Append(", P0Added = " + P0Added);
            stringBuilder.Append(", P1Added = " + P1Added);
            stringBuilder.Append(", P2Added = " + P2Added);
            stringBuilder.Append(", P3Added = " + P3Added);
            stringBuilder.Append(", P0Approved = " + P0Approved);
            stringBuilder.Append(", P1Approved = " + P1Approved);
            stringBuilder.Append(", P2Approved = " + P2Approved);
            stringBuilder.Append(", P3Approved = " + P3Approved);
            stringBuilder.Append(", TotalCount = " + TotalCount);
            return stringBuilder.ToString();
        }
    }
}
