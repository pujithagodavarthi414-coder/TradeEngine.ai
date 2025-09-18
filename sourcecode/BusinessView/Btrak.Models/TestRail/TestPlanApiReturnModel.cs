using System;
using System.Collections.Generic;
using System.Text;

namespace Btrak.Models.TestRail
{
    public class TestPlanApiReturnModel
    {
        public Guid? TestPlanId { get; set; }

        public Guid? ProjectId { get; set; }

        public string TestPlanName { get; set; }

        public Guid? MilestoneId { get; set; }

        public string MilestoneName { get; set; }

        public string Description { get; set; }

        public List<TestPlanSelectedSuite> TestPlanSelectedSuites { get; set; }

        public List<Guid> TestSuiteIds { get; set; }

        public bool? IsArchived { get; set; }

        public bool? IsCompleted { get; set; }

        public byte[] TimeStamp { get; set; }

        public string MilestoneTitle { get; set; } 

        public string TestSuiteIdsXml { get; set; }

        public DateTime CreatedDateTime { get; set; }

        public Guid?   CreatedByUserId { get; set; }

        public int? TotalCount { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("TestPlanId = " + TestPlanId);
            stringBuilder.Append(", ProjectId = " + ProjectId);
            stringBuilder.Append(", TestPlanName = " + TestPlanName);
            stringBuilder.Append(", MilestoneId = " + MilestoneId);
            stringBuilder.Append(", MilestoneName = " + MilestoneName);
            stringBuilder.Append(", Description = " + Description);
            stringBuilder.Append(", TestPlanSelectedSuites = " + TestPlanSelectedSuites);
            stringBuilder.Append(", TestSuiteIds = " + TestSuiteIds);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", IsCompleted = " + IsCompleted);
            stringBuilder.Append(", MilestoneTitle = " + MilestoneTitle);
            stringBuilder.Append(", TestSuiteIdsXml = " + TestSuiteIdsXml);
            stringBuilder.Append(", CreatedDateTime = " + CreatedDateTime);
            stringBuilder.Append(", CreatedByUserId = " + CreatedByUserId);
            stringBuilder.Append(", TotalCount = " + TotalCount);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            return stringBuilder.ToString();
        }
    }
}
