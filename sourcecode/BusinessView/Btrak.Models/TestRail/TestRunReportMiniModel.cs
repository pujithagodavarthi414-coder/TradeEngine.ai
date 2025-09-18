using System;

namespace Btrak.Models.TestRail
{
    public class TestRunReportMiniModel
    {
        public Guid? TestRunId { get; set; }

        public string TestRunName { get; set; }

        public string NewTestRunName { get; set; }

        public bool IsCompleted { get; set; }

        public bool IsArchived { get; set; }
    }
}
