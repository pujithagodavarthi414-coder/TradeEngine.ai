using System;
using System.Collections.Generic;
using System.Text;

namespace Btrak.Models.TestRail
{
    public class TestSuiteCasesOverviewModel
    {
        public TestSuiteCasesOverviewModel()
        {
            TestRunSelectedCases = new List<TestRunSelectedCaseMiniModel>();

            TestRunSelectedSections = new List<Guid?>();

            Sections = new List<TestSuiteSectionOverviewModel>();
        }

        public string TestSuiteName { get; set; }

        public Guid? TestSuiteId { get; set; }

        public string Description { get; set; }

        public int? SectionsCount { get; set; }

        public int? CasesCount { get; set; }

        public List<TestRunSelectedCaseMiniModel> TestRunSelectedCases { get; set; }

        public List<Guid?> TestRunSelectedSections { get; set; }

        public List<TestSuiteSectionOverviewModel> Sections { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("TestSuiteName = " + TestSuiteName);
            stringBuilder.Append(", TestSuiteId = " + TestSuiteId);
            stringBuilder.Append(", Sections = " + Sections);
            stringBuilder.Append(", SectionsCount = " + SectionsCount);
            stringBuilder.Append(", CasesCount = " + CasesCount);
            stringBuilder.Append(", TestRunSelectedCases = " + TestRunSelectedCases);
            stringBuilder.Append(", TestRunSelectedSections = " + TestRunSelectedSections);
            return stringBuilder.ToString();
        }
    }
}