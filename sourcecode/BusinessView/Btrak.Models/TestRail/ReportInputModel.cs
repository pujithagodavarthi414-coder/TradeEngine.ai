using System;
using System.Text;

namespace Btrak.Models.TestRail
{
    public class ReportInputModel 
    {
        public Guid? TestRailReportId { get; set; }
        public string ReportName { get; set; }
        public Guid? MilestoneId { get; set; }
        public Guid? ProjectId { get; set; }
        public string Description { get; set; }
        public Guid? TestRunId { get; set; }
        public Guid? TestPlanId { get; set; }
        public Guid? TestRailOptionId { get; set; }
        public bool IsArchived { get; set; }
        public string PdfUrl { get; set; }
        public byte[] TimeStamp { get; set; }
        public bool IsFromGeneratedPdf { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("ReportId" + TestRailReportId);
            stringBuilder.Append(", ReportName" + ReportName);
            stringBuilder.Append(", MilestoneId" + MilestoneId);
            stringBuilder.Append(", ProjectId" + ProjectId);
            stringBuilder.Append(", Description" + Description);
            stringBuilder.Append(", TestRunId" + TestRunId);
            stringBuilder.Append(", TestPlanId" + TestPlanId);
            stringBuilder.Append(", TestRailOptionId" + TestRailOptionId);
            stringBuilder.Append(", IsArchived" + IsArchived);
            stringBuilder.Append(", PdfUrl" + PdfUrl);
            stringBuilder.Append(", TimeStamp" + TimeStamp);
            return stringBuilder.ToString();
        }
    }
}
