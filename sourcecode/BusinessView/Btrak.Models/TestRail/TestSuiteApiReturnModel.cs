using System;
using System.Text;

namespace Btrak.Models.TestRail
{
    public class TestSuiteApiReturnModel
    {
        public Guid? TestSuiteId { get; set; }

        public Guid? ProjectId { get; set; }

        public string TestSuiteName { get; set; }

        public string Description { get; set; }

        public bool IsArchived { get; set; }

        public byte[] TimeStamp { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("ProjectId = " + ProjectId);
            stringBuilder.Append(", TestSuiteId = " + TestSuiteId);
            stringBuilder.Append(", TestSuiteName = " + TestSuiteName);
            stringBuilder.Append(", Description = " + Description);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            return stringBuilder.ToString();
        }
    }
}
