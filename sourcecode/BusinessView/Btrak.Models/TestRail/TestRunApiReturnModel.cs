using System;
using System.Collections.Generic;
using System.Text;

namespace Btrak.Models.TestRail
{
    public class TestRunApiReturnModel
    {
        public Guid? TestRunId { get; set; }

        public Guid? ProjectId { get; set; }

        public string TestRunName { get; set; }

        public Guid? MilestoneId { get; set; }

        public string MilestoneName { get; set; }

        public Guid? AssignToId { get; set; }

        public string AssignToName { get; set; }

        public string AssigneeProfileImage { get; set; }

        public string Description { get; set; }

        public bool? IsIncludeAllCases { get; set; }

        public List<Guid> SelectedCases { get; set; }

        public bool? IsCompleted { get; set; }

        public bool IsArchived { get; set; }

        public string TotalEstimate { get; set; }

        public int NoEstimateCasesCount { get; set; }

        public byte[] TimeStamp { get; set; }

        public Guid? TestSuiteId { get; set; }

        public string TestSuiteName { get; set; }

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

        public int? TotalCount { get; set; }

        public int? CasesCount { get; set; }
       
        public DateTime CreatedDateTime { get; set; }

        public Guid? CreatedByUserId { get; set; }

        public string CreatedBy { get; set; }

        public string CreatedByProfileImage { get; set; }

        public string TestCaseStepsXml { get; set; }

        public TestSuiteCasesOverviewModel TestSuiteCases { get; set; }

        public string SelectedCasesXml { get; set; }

        public List<TestCaseOverviewModel> SelectedCasesDetails { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("TestRunId = " + TestRunId);
            stringBuilder.Append(", ProjectId = " + ProjectId);
            stringBuilder.Append(", TestRunName = " + TestRunName);
            stringBuilder.Append(", MilestoneId = " + MilestoneId);
            stringBuilder.Append(", MilestoneName = " + MilestoneName);
            stringBuilder.Append(", TestSuiteId = " + TestSuiteId);
            stringBuilder.Append(", TestSuiteName = " + TestSuiteName);
            stringBuilder.Append(", AssignToId = " + AssignToId);
            stringBuilder.Append(", AssignToName = " + AssignToName);
            stringBuilder.Append(", AssigneeProfileImage = " + AssigneeProfileImage);
            stringBuilder.Append(", CasesCount = " + CasesCount);
            stringBuilder.Append(", CreatedBy = " + CreatedBy);
            stringBuilder.Append(", CreatedByProfileImage = " + CreatedByProfileImage);
            stringBuilder.Append(", Description = " + Description);
            stringBuilder.Append(", PassedCount = " + PassedCount);
            stringBuilder.Append(", UntestedCount = " + UntestedCount);
            stringBuilder.Append(", BlockedCount = " + BlockedCount);
            stringBuilder.Append(", FailedCount = " + FailedCount);
            stringBuilder.Append(", RetestCount = " + RetestCount);
            stringBuilder.Append(", PassedPercent = " + PassedPercent);
            stringBuilder.Append(", BlockedPercent = " + BlockedPercent);
            stringBuilder.Append(", RetestPercent = " + RetestPercent);
            stringBuilder.Append(", FailedPercent = " + FailedPercent);
            stringBuilder.Append(", UntestedPercent = " + UntestedPercent);
            stringBuilder.Append(", IsIncludeAllCases = " + IsIncludeAllCases);
            stringBuilder.Append(", SelectedCases = " + SelectedCases);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", IsCompleted = " + IsCompleted);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            stringBuilder.Append(", TotalCount = " + TotalCount);
            stringBuilder.Append(", SelectedCasesXml = " + SelectedCasesXml);
            stringBuilder.Append(", SelectedCasesDetails = " + SelectedCasesDetails);
            return stringBuilder.ToString();
        }
    }
}
