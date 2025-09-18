using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.TestRail
{
    public class ReportsHierarchyReturnModel
    {
        public Guid? SectionId { get; set; }

        public string SectionName { get; set; }

        public Guid? ParentSectionId { get; set; }

        public int CasesCount { get; set; }

        public string TestCasesXml { get; set; }

        public List<TestRailReportsMiniModel> TestCases { get; set; }

        public List<ReportsHierarchyReturnModel> SubSections { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("SectionId = " + SectionId);
            stringBuilder.Append(", SectionName = " + SectionName);
            stringBuilder.Append(", ParentSectionId = " + ParentSectionId);
            stringBuilder.Append(", CasesCount = " + CasesCount);
            stringBuilder.Append(", TestCasesXml = " + TestCasesXml);
            return stringBuilder.ToString();
        }

    }
}
