using System;
using System.Text;

namespace Btrak.Models.TestRail
{
    public class TestSuiteCasesOverviewInputModel
    {
        public Guid? TestRunId { get; set; }

        public Guid? TestSuiteId { get; set; }

        public Guid? SectionId { get; set; }

        public bool IncludeTestCases { get; set; }

        public bool IncludeRunCases { get; set; }

        public bool? IsSectionsRequired { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(" TestRunId = " + TestRunId);
            stringBuilder.Append(", TestSuiteId = " + TestSuiteId);
            stringBuilder.Append(", SectionId = " + SectionId);
            stringBuilder.Append(", IncludeTestCases = " + IncludeTestCases);
            stringBuilder.Append(", IncludeRunCases = " + IncludeRunCases);
            stringBuilder.Append(", IsSectionsRequired = " + IsSectionsRequired);
            return stringBuilder.ToString();
        }
    }
}
