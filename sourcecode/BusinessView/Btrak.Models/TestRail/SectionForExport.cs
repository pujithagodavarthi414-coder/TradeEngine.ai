using System;
using System.Collections.Generic;
using System.Text;

namespace Btrak.Models.TestRail
{
    public class SectionForExport
    {

        public string SectionName { get; set; }

        public string ParentSectionName { get; set; }

        public string Description { get; set; }

        public DateTime? CreatedDateTime { get; set; }

        public List<TestCasesForExport> TestCases { get; set; }

    }
}