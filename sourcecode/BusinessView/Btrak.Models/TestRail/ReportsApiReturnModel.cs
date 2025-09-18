using System;
using System.Collections.Generic;
using System.Text;

namespace Btrak.Models.TestRail
{
    public class ReportsApiReturnModel
    {
        public Guid? TestRailReportId { get; set; }

        public string TestRailReportName { get; set; }

        public string Description { get; set; }

        public Guid? MilestoneId { get; set; }

        public string MilestoneName { get; set; }

        public string PdfUrl { get; set; }

        public Guid? ProjectId { get; set; }

        public Guid? TestRunId { get; set; }

        public Guid? TestRailReportOptionId { get; set; }

        public DateTime? CreatedDateTime { get; set; }

        public Guid? CreatedByUserId { get; set; }

        public string CreatedBy { get; set; }

        public string CreatedByProfileImage { get; set; }

        public string ProjectName { get; set; }

        public int VersionNumber { get; set; }

        public string TestCasesXml { get; set; }

        public string TestRunsXml { get; set; }

        public List<TestRailReportsMiniModel> TestCases { get; set; }

        public List<TestRunReportMiniModel> TestRuns { get; set; }

        public byte[] TimeStamp { get; set; }

        public int TotalCount { get; set; }

        public int CasesCount { get; set; }

        public int PassedCount { get; set; }

        public int BlockedCount { get; set; }

        public int RetestCount { get; set; }

        public int FailedCount { get; set; }

        public int UntestedCount { get; set; }

        public int PassedPercent { get; set; }

        public int BlockedPercent { get; set; }

        public int RetestPercent { get; set; }

        public int FailedPercent { get; set; }

        public int UntestedPercent { get; set; }

        public int ReportCasesCount { get; set; }

        public int HierarchyCasesCount { get; set; }

        public List<ReportsHierarchyReturnModel> HierarchyTree { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("TestRailReportId = " + TestRailReportId);
            stringBuilder.Append(", TestRailReportName = " + TestRailReportName);
            stringBuilder.Append(", Description = " + Description);
            stringBuilder.Append(", PdfUrl = " + PdfUrl);
            stringBuilder.Append(", MilestoneName = " + MilestoneName);
            stringBuilder.Append(", MilestoneId = " + MilestoneId);
            stringBuilder.Append(", ProjectId = " + ProjectId);
            stringBuilder.Append(", TestRailReportOptionId = " + TestRailReportOptionId);
            stringBuilder.Append(", CreatedDateTime = " + CreatedDateTime);
            stringBuilder.Append(", CreatedByUserId = " + CreatedByUserId);
            stringBuilder.Append(", CreatedBy = " + CreatedBy);
            stringBuilder.Append(", CreatedByProfileImage = " + CreatedByProfileImage);
            stringBuilder.Append(", ProjectName = " + ProjectName);
            stringBuilder.Append(", VersionNumber = " + VersionNumber);
            stringBuilder.Append(", TestCasesXml = " + TestCasesXml);
            stringBuilder.Append(", TestRunsXml = " + TestRunsXml);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            stringBuilder.Append(", TotalCount = " + TotalCount);
            stringBuilder.Append(", CasesCount = " + CasesCount);
            stringBuilder.Append(", PassedCount = " + PassedCount);
            stringBuilder.Append(", BlockedCount = " + BlockedCount);
            stringBuilder.Append(", RetestCount = " + RetestCount);
            stringBuilder.Append(", FailedCount = " + FailedCount);
            stringBuilder.Append(", UntestedCount = " + UntestedCount);
            stringBuilder.Append(", PassedPercent = " + PassedPercent);
            stringBuilder.Append(", BlockedPercent = " + BlockedPercent);
            stringBuilder.Append(", RetestPercent = " + RetestPercent);
            stringBuilder.Append(", FailedPercent = " + FailedPercent);
            stringBuilder.Append(", UntestedPercent = " + UntestedPercent);
            stringBuilder.Append(", ReportCasesCount = " + ReportCasesCount);
            stringBuilder.Append(", HierarchyCasesCount = " + HierarchyCasesCount);
            return stringBuilder.ToString();
        }
    }
}
