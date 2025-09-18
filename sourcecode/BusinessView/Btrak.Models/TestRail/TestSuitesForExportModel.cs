using System;
using System.Collections.Generic;
using System.Text;

namespace Btrak.Models.TestRail
{
    public class TestSuitesForExportModel
    {
        public string TestSuiteName { get; set; }

        public string Description { get; set; }

        public DateTime? CreatedDateTime { get; set; }

        public List<SectionForExport> Sections { get; set; }

    }
}