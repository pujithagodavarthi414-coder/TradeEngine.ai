using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.TestRail
{
    public class TestSuiteSectionInputModel : InputModelBase
    {
        public TestSuiteSectionInputModel() : base(InputTypeGuidConstants.TestSuiteSectionInputCommandTypeGuid)
        {
        }

        public Guid? TestSuiteSectionId { get; set; }

        public Guid? TestSuiteId { get; set; }

        public string SectionName { get; set; }

        public string Description { get; set; }

        public Guid? ParentSectionId { get; set; }

        public bool IsArchived { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("TestSuiteSectionId = " + TestSuiteSectionId);
            stringBuilder.Append(", TestSuiteId = " + TestSuiteId);
            stringBuilder.Append(", SectionName = " + SectionName);
            stringBuilder.Append(", Description = " + Description);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            return stringBuilder.ToString();
        }
    }
}
