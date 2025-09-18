using System;
using System.Collections.Generic;
using System.Text;

namespace Btrak.Models.TestRail
{
    public class TestCaseHistoryInputModel
    {
        public Guid? TestRunId { get; set; }
        public Guid? ReportId { get; set; }

        public Guid? TestCaseId { get; set; }

        public Guid? UserStoryId { get; set; }

    }
}
