using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.TestRail
{
    public class TestCaseTitleInputModel : InputModelBase
    {
        public TestCaseTitleInputModel() : base(InputTypeGuidConstants.TestCaseTitleUserInputCommandTypeGuid)
        {
        }

        public Guid? TestCaseId { get; set; }

        public Guid? TestSuiteId { get; set; }

        public string Title { get; set; }

        public Guid? SectionId { get; set; }

        public bool IsArchived { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("TestCaseId = " + TestCaseId);
            stringBuilder.Append(", TestSuiteId = " + TestSuiteId);
            stringBuilder.Append(", SectionId = " + SectionId);
            stringBuilder.Append(", Title = " + Title);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            return stringBuilder.ToString();
        }
    }
}
