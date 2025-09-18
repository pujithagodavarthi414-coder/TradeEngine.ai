using System;
using System.Collections.Generic;
using System.Text;

namespace Btrak.Models.TestRail
{
    public class TestSuiteOverviewModel
    {
        public Guid? ProjectId { get; set; }

        public Guid? TestSuiteId { get; set; }

        public string Description { get; set; }

        public string TestSuiteName { get; set; }

        public bool IsArchived { get; set; }

        public int? SectionsCount { get; set; }

        public int? CasesCount { get; set; }

        public int? RunsCount { get; set; }

        public int? TotalCount { get; set; }

        public string TotalEstimate { get; set; }

        public int NoEstimateCasesCount { get; set; }

        public byte[] TimeStamp { get; set; }

        public int? MileStonesCount { get; set; }

        public string ProjectName { get; set; }

        public DateTime CreatedDateTime { get; set; }

        public string CreatedByName { get; set; }

        public string CreatedByProfileImage { get; set; }
        
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("ProjectId = " + ProjectId);
            stringBuilder.Append(", TestSuiteId = " + TestSuiteId);
            stringBuilder.Append(", TestSuiteName = " + TestSuiteName);
            stringBuilder.Append(", Description = " + Description);
            stringBuilder.Append(", SectionsCount = " + SectionsCount);
            stringBuilder.Append(", CasesCount = " + CasesCount);
            stringBuilder.Append(", RunsCount = " + RunsCount);
            stringBuilder.Append(", TotalCount = " + TotalCount);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            stringBuilder.Append(", MileStonesCount = " + MileStonesCount);
            stringBuilder.Append(", ProjectName = " + ProjectName);
            stringBuilder.Append(", CreatedDateTime = " + CreatedDateTime);
            stringBuilder.Append(", CreatedByName = " + CreatedByName);
            stringBuilder.Append(", TotalEstimate = " + TotalEstimate);
            stringBuilder.Append(", NoEstimateCasesCount = " + NoEstimateCasesCount);
            stringBuilder.Append(", CreatedByProfileImage = " + CreatedByProfileImage);
            return stringBuilder.ToString();
        }
    }
}
