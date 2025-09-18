using System;
using System.Text;

namespace Btrak.Models.TestRail
{
    public class TestRailProjectApiReturnModel
    {
        public Guid ProjectId { get; set; }

        public string ProjectName { get; set; }

        public string ProjectResponsiblePersonProfileImage { get; set; }

        public Guid ? ProjectResponsiblePersonId { get; set; }

        public string ProjectResponsiblePersonName { get; set; }
        
        public int? CasesCount { get; set; }

        public int? TestSuiteCount { get; set; }

        public int? TestRunCount { get; set; }

        public int? MilestoneCount { get; set; }

        public int? ReportsCount { get; set; }

        public int? CompletedMilestoneCount { get; set; }

        public int? OpenMilestoneCount { get; set; }

        public int? OpenTestRunCount { get; set; }

        public int? CompletedTestRunCount { get; set; }

        public int? TotalCount { get; set; }

        public byte[] TimeStamp { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("ProjectId = " + ProjectId);
            stringBuilder.Append(", ProjectName = " + ProjectName);
            stringBuilder.Append(", ProjectResponsiblePersonProfileImage = " + ProjectResponsiblePersonProfileImage);
            stringBuilder.Append(", ProjectResponsiblePersonId = " + ProjectResponsiblePersonId);
            stringBuilder.Append(", ProjectResponsiblePersonName = " + ProjectResponsiblePersonName);
            stringBuilder.Append(", CasesCount = " + CasesCount);
            stringBuilder.Append(", TestSuiteCount = " + TestSuiteCount);
            stringBuilder.Append(", TestRunCount = " + TestRunCount);
            stringBuilder.Append(", CompletedMilestoneCount = " + CompletedMilestoneCount);
            stringBuilder.Append(", OpenMilestoneCount = " + OpenMilestoneCount);
            stringBuilder.Append(", OpenTestRunCount = " + OpenTestRunCount);
            stringBuilder.Append(", CompletedTestRunCount = " + CompletedTestRunCount);
            stringBuilder.Append(", MilestoneCount = " + MilestoneCount);
            stringBuilder.Append(", ReportsCount = " + ReportsCount);
            stringBuilder.Append(", TotalCount = " + TotalCount);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            return stringBuilder.ToString();
        }
    }
}
