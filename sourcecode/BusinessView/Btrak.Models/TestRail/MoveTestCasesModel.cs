using System;
using System.Collections.Generic;
using System.Text;

namespace Btrak.Models.TestRail
{
    public class MoveTestCasesModel
    {
        public List<Guid> TestCaseIds { get; set; }
        public string TestCaseIdsXml { get; set; }
        public Guid? SectionId { get; set; }
        public bool? IsCopy { get; set; }
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("TestCaseIds = " + TestCaseIds);
            stringBuilder.Append("TestCaseIdsXml = " + TestCaseIdsXml);
            stringBuilder.Append("SectionId = " + SectionId);
            return stringBuilder.ToString();
        }
    }
}
