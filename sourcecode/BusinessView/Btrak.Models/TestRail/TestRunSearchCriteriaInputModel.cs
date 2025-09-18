using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.TestRail
{
    public class TestRunSearchCriteriaInputModel : SearchCriteriaInputModelBase
    {
        public TestRunSearchCriteriaInputModel() : base(InputTypeGuidConstants.TestRunSearchCriteriaInputCommandTypeGuid)
        {
        }

        public Guid? TestRunId { get; set; }

        public Guid? ProjectId { get; set; }

        public Guid? TestSuiteId { get; set; }

        public string TestRunName { get; set; }

        public Guid? MilestoneId { get; set; }

        public Guid? AssignToId { get; set; }

        public string Description { get; set; }

        public bool? IsIncludeAllCases { get; set; }

        public Guid? TestPlanId { get; set; }

        public bool? IsCompleted { get; set; }

        public DateTime? DateFrom { get; set; }

        public DateTime? DateTo { get; set; }

        public Guid? CreatedBy { get; set; }

        public string TestRunIds { get; set; }

        public string TestrunIdsXml { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("TestRunId = " + TestRunId);
            stringBuilder.Append(", ProjectId = " + ProjectId);
            stringBuilder.Append(", TestSuiteId = " + TestSuiteId);
            stringBuilder.Append(", TestRunName = " + TestRunName);
            stringBuilder.Append(", MilestoneId = " + MilestoneId);
            stringBuilder.Append(", AssignToId = " + AssignToId);
            stringBuilder.Append(", Description = " + Description);
            stringBuilder.Append(", IsIncludeAllCases = " + IsIncludeAllCases);
            stringBuilder.Append(", TestPlanId = " + TestPlanId);
            stringBuilder.Append(", IsCompleted = " + IsCompleted);
            stringBuilder.Append(", DateFrom = " + DateFrom);
            stringBuilder.Append(", DateTo = " + DateTo);
            stringBuilder.Append(", CreatedBy = " + CreatedBy);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            return stringBuilder.ToString();
        }
    }
}
