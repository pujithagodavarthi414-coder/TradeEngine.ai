using System;
using System.Collections.Generic;
using System.Text;

namespace Btrak.Models.TestRail
{
    public class TestPlanSelectedSuite
    {
        public Guid? TestPlanId { get; set; }

        public Guid? TestSuiteId { get; set; }

        public string TestSuiteName { get; set; }

        public int? SelectedCasesCount { get; set; }

        public List<Guid> SelectedCaseIds { get; set; }

        public string AssignTo { get; set; }

        public byte[] TimeStamp { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("TestPlanId = " + TestPlanId);
            stringBuilder.Append(", TestSuiteId = " + TestSuiteId);
            stringBuilder.Append(", TestSuiteName = " + TestSuiteName);
            stringBuilder.Append(", SelectedCasesCount = " + SelectedCasesCount);
            stringBuilder.Append(", SelectedCaseIds = " + SelectedCaseIds);
            stringBuilder.Append(", AssignTo = " + AssignTo);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            return stringBuilder.ToString();
        }
    }
}
