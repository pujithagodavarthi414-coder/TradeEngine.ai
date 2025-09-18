using System;

namespace Btrak.Models.TestRail
{
    public class TestRunSelectedCaseMiniModel
    {
        public Guid? TestCaseId { get; set; }
        public Guid? SectionId { get; set; }
        public bool IsChecked { get; set; }
        public int TestCasesCount { get; set; }
    }
}
