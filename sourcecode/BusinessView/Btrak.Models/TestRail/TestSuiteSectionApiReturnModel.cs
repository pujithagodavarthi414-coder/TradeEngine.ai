using System;
using System.Text;

namespace Btrak.Models.TestRail
{
    public class TestSuiteSectionApiReturnModel
    {
        public Guid? TestSuiteSectionId { get; set; }

        public Guid? TestSuiteId { get; set; }

        public Guid? ParentSectionId { get; set; }

        public string SectionName { get; set; }

        public string ParentSectionName { get; set; }

        public string Description { get; set; }

        public bool IsArchived { get; set; }

        public bool IsSelectedSection { get; set; }

        public int CasesCount { get; set; }

        public int SectionEstimate { get; set; }

        public string TotalEstimate { get; set; }

        public int NoEstimateCasesCount { get; set; }

        public int SectionLevel { get; set; }

        public byte[] TimeStamp { get; set; }

        public string TestSuiteName { get; set;}

        public string TestSuiteDescription { get; set; }

        public DateTime CreatedDateTime { get; set; }

        public Guid? CreatedByUserId { get; set; }

        public int? TotalCount { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("TestSuiteSectionId = " + TestSuiteSectionId);
            stringBuilder.Append(", TestSuiteId = " + TestSuiteId);
            stringBuilder.Append(", SectionName = " + SectionName);
            stringBuilder.Append(", Description = " + Description);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", IsSelectedSection = " + IsSelectedSection);
            stringBuilder.Append(", CasesCount = " + CasesCount);
            stringBuilder.Append(", SectionLevel = " + SectionLevel);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            stringBuilder.Append(", TestSuiteName = " + TestSuiteName);
            stringBuilder.Append(", SectionEstimate = " + SectionEstimate);
            stringBuilder.Append(", CreatedDateTime = " + CreatedDateTime);
            stringBuilder.Append(", CreatedByUserId = " + CreatedByUserId);
            stringBuilder.Append(", TotalCount = " + TotalCount);
            return stringBuilder.ToString();
        }
    }
}
