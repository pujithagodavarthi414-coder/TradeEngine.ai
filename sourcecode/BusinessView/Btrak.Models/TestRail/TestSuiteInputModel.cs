using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.TestRail
{
    public class TestSuiteInputModel : InputModelBase
    {
        public TestSuiteInputModel() : base(InputTypeGuidConstants.TestSuiteInputCommandTypeGuid)
        {
        }

        public Guid? TestSuiteId { get; set; }

        public Guid? ProjectId { get; set; }

        public string TestSuiteName { get; set; }

        public string Description { get; set; }

        public bool IsArchived { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(" TestSuiteId = " + TestSuiteId);
            stringBuilder.Append(", ProjectId = " + ProjectId);
            stringBuilder.Append(", TestSuiteName = " + TestSuiteName);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            stringBuilder.Append(", Description = " + Description);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            return stringBuilder.ToString();
        }
    }
}
