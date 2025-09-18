using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.TestRail
{
    public class SearchTestCasesModel
    {
        public Guid? TestCaseId { get; set; }
        public string Title { get; set; }
        public Guid? SectionId { get; set; }
        public string TestCaseIdentity { get; set; }
        public byte[] TimeStamp { get; set; }
        public Guid? TestSuiteId { get; set; }
        public int Estimate { get; set; }
        public int TotalCount { get; set; }
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("TestCaseId = " + TestCaseId);
            stringBuilder.Append(", TestCaseIdentity = " + TestCaseIdentity);
            stringBuilder.Append(", TestSuiteId = " + TestSuiteId);
            stringBuilder.Append(", Title = " + Title);
            stringBuilder.Append(", SectionId = " + SectionId);
            stringBuilder.Append(", Estimate = " + Estimate);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            stringBuilder.Append(", TotalCount = " + TotalCount);
            return stringBuilder.ToString();
        }
    }
}
