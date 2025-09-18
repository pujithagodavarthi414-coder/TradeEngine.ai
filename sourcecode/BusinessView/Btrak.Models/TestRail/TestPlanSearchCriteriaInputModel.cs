using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.TestRail
{
    public class TestPlanSearchCriteriaInputModel : SearchCriteriaInputModelBase
    {
        public TestPlanSearchCriteriaInputModel() : base(InputTypeGuidConstants.TestPlanSearchCriteriaInputCommandTypeGuid)
        {
        }

        public Guid? TestPlanId { get; set; }

        public Guid? ProjectId { get; set; }

        public string TestPlanName { get; set; }

        public Guid? MilestoneId { get; set; }

        public string Description { get; set; }

        public bool? IsCompleted { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("TestPlanId = " + TestPlanId);
            stringBuilder.Append(", ProjectId = " + ProjectId);
            stringBuilder.Append(", TestPlanName = " + TestPlanName);
            stringBuilder.Append(", MilestoneId = " + MilestoneId);
            stringBuilder.Append(", Description = " + Description);
            stringBuilder.Append(", IsCompleted = " + IsCompleted);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            return stringBuilder.ToString();
        }
    }
}
