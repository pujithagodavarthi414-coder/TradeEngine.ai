using System;
using System.Collections.Generic;
using System.Text;

namespace Btrak.Models.TestRail
{
    public class TestSuiteSectionOverviewModel
    {
        public string SectionName { get; set; }

        public Guid? SectionId { get; set; }

        public int SectionLevel { get; set; }

        public int? CasesCount { get; set; }

        public string TotalEstimate { get; set; }

        public float SectionEstimate { get; set; }

        public int NoEstimateCasesCount { get; set; }

        public Guid? ParentSectionId { get; set; }

        public string Description { get; set; }

        public bool IsSelectedSection { get; set; }

        public byte[] TimeStamp { get; set; }

        public List<TestCaseApiReturnModel> TestCases { get; set; }

        public List<TestSuiteSectionOverviewModel> SubSections { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("SectionName = " + SectionName);
            stringBuilder.Append(", SectionId = " + SectionId);
            stringBuilder.Append(", SectionLevel = " + SectionLevel);
            stringBuilder.Append(", SectionCasesCount = " + CasesCount);
            stringBuilder.Append(", ParentSectionId =" + ParentSectionId);
            stringBuilder.Append(", IsSelectedSection =" + IsSelectedSection);
            stringBuilder.Append(", TestCases = " + TestCases);
            stringBuilder.Append(", SubSection = " + SubSections);
            return stringBuilder.ToString();
        }
    }
}
