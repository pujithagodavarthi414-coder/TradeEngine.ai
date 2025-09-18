using System.Text;

namespace Btrak.Models.TestRail
{
    public class ReportModel
    {
        public int PassedCount { get; set; }

        public int BlockedCount { get; set; }

        public int RetestCount { get; set; }

        public int FailedCount { get; set; }

        public int UntestedCount { get; set; }

        public int TotalCount { get; set; }

        public int? PassedPercent { get; set; }

        public int? BlockedPercent { get; set; }

        public int? RetestPercent { get; set; }

        public int? FailedPercent { get; set; }

        public int? UntestedPercent { get; set; }

        public int? TestedPercent { get; set; }

        public int? TestedCount { get; set; }

        public int? TotalCasesCount { get; set; }

        public byte[] TimeStamp { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("PassedCount = " + PassedCount);
            stringBuilder.Append(", BlockedCount = " + BlockedCount);
            stringBuilder.Append(", RetestCount = " + RetestCount);
            stringBuilder.Append(", FailedCount = " + FailedCount);
            stringBuilder.Append(", UntestedCount = " + UntestedCount);
            stringBuilder.Append(", TotalCount = " + TotalCount);
            stringBuilder.Append(", PassedPercent = " + PassedPercent);
            stringBuilder.Append(", BlockedPercent = " + BlockedPercent);
            stringBuilder.Append(", RetestPercent = " + RetestPercent);
            stringBuilder.Append(", FailedPercent = " + FailedPercent);
            stringBuilder.Append(", UntestedPercent = " + UntestedPercent);
            stringBuilder.Append(", TestedPercent = " + TestedPercent);
            stringBuilder.Append(", TestedCount = " + TestedCount);
            stringBuilder.Append(", TotalCasesCount = " + TotalCasesCount);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            return stringBuilder.ToString();
        }
    }
}
