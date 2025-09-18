using System;

namespace Btrak.Models.TestRail
{
    public class TestRailReportsMiniModel
    {
        public Guid? TestCaseId { get; set; }

        public Guid? TestRunId { get; set; }

        public string Title { get; set; }

        public Guid? AssignToId { get; set; }

        public string TestCaseIdentity { get; set; }

        public string StatusName { get; set; }

        public string StatusColor { get; set; }

        public string AssignToName { get; set; }

        public string CreatedUserName { get; set; }

        public string TestedByUserName { get; set; }

        public string AssignToProfileImage { get; set; }

        public bool IsDeleted { get; set; }

        public Guid? CreatedByUserId { get; set; }

        public int TotalCount { get; set; }
    }
}
