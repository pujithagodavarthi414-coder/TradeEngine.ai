using System;
using System.Text;

namespace Btrak.Models.TestRail
{
    public class SelectedTestCaseModel
    {
        public Guid? TestSuiteId { get; set; }

        public Guid? TestCaseId { get; set; }

        public Guid? SectionId { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("TestSuiteId = " + TestSuiteId);
            stringBuilder.Append("TestCaseId = " + TestCaseId);
            stringBuilder.Append("SectionId = " + SectionId);
            return stringBuilder.ToString();
        }
    }

    
}
