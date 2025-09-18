using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.TestRail
{
    public class TestSuiteSectionSearchCriteriaInputModel : SearchCriteriaInputModelBase
    {
        public TestSuiteSectionSearchCriteriaInputModel() : base(InputTypeGuidConstants.TestSuiteSectionSearchCriteriaInputCommandTypeGuid)
        {
        }

        public Guid? TestSuiteSectionId { get; set; }

        public Guid? TestRunId { get; set; }

        public Guid? TestSuiteId { get; set; }

        public Guid? ParentSectionId { get; set; }

        public string SectionName { get; set; }

        public string Description { get; set; }

        public bool? IsSectionsRequired { get; set; }

        public bool IsFromTestRunUplaods { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("TestSuiteSectionId = " + TestSuiteSectionId);
            stringBuilder.Append(", TestSuiteId = " + TestSuiteId);
            stringBuilder.Append(", ParentSectionId = " + ParentSectionId);
            stringBuilder.Append(", SectionName = " + SectionName);
            stringBuilder.Append(", Description = " + Description);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            stringBuilder.Append(", IsSectionsRequired = " + IsSectionsRequired);
            stringBuilder.Append(", IsFromTestRunUplaods = " + IsFromTestRunUplaods);
            return stringBuilder.ToString();
        }
    }
}
