using System;
using System.Text;

namespace Btrak.Models.TestRail
{
    public class TestRailOverviewCountsModel
    {
        public Guid? ProjectId { get; set; }
        public int? TestRunCount { get; set; }
        public int? MilestoneCount { get; set; }
        public int? OpenMilestoneCount { get; set; }
        public int? CompletedMilestoneCount { get; set; }
        public int? OpenTestRunCount { get; set; }
        public int? CompletedTestRunCount { get; set; }
        public int? TestSuiteCount { get; set; }
        public int? CasesCount { get; set; }
        public int? ReportCount { get; set; }
        public string ProjectName { get; set; }
        public Guid? ProjectResponsiblePersonId { get; set; }
        public string ProjectResponsiblePersonProfileImage { get; set; }
        public string ProjectResponsiblePersonName { get; set; }
        public int? TotalCount { get; set; }


        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("ProjectId =" + ProjectId);
            stringBuilder.Append(", OpenMilestoneCount = " + OpenMilestoneCount);
            stringBuilder.Append(", CompletedMilestoneCount = " + CompletedMilestoneCount);
            stringBuilder.Append(", OpenTestRunsCount = " + OpenTestRunCount);
            stringBuilder.Append(", CompletedTestRunsCount = " + CompletedTestRunCount);
            stringBuilder.Append(", TestSuitesCount = " + TestSuiteCount);
            stringBuilder.Append(", TestCasesCount = " + CasesCount);
            stringBuilder.Append(", TestRunCount = " + TestRunCount);
            stringBuilder.Append(", MilestoneCount = " + MilestoneCount);
            stringBuilder.Append(", ReportCount = " + ReportCount);
            stringBuilder.Append(", ProjectName = " + ProjectName);
            stringBuilder.Append(", ProjectResponsiblePersonId = " + ProjectResponsiblePersonId);
            stringBuilder.Append(", ProjectResponsiblePersonProfileImage = " + ProjectResponsiblePersonProfileImage);
            stringBuilder.Append(", ProjectResponsiblePersonName = " + ProjectResponsiblePersonName);
            stringBuilder.Append(", TotalCount = " + TotalCount);

            return stringBuilder.ToString();
        }
    }
}
