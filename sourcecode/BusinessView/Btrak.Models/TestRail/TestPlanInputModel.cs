using System;
using System.Collections.Generic;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.TestRail
{
    public class TestPlanInputModel : InputModelBase
    {
        public TestPlanInputModel() : base(InputTypeGuidConstants.TestPlanInputCommandTypeGuid)
        {
        }

        public Guid? TestPlanId { get; set; }

        public Guid? ProjectId { get; set; }

        public string TestPlanName { get; set; }

        public Guid? MilestoneId { get; set; }

        public string Description { get; set; }

        public List<Guid> TestSuiteIds { get; set; }

        public bool IsArchived { get; set; }

        public bool IsCompleted { get; set; }

       
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("TestPlanId = " + TestPlanId);
            stringBuilder.Append(", ProjectId = " + ProjectId);
            stringBuilder.Append(", TestPlanName = " + TestPlanName);
            stringBuilder.Append(", MilestoneId = " + MilestoneId);
            stringBuilder.Append(", Description = " + Description);
            stringBuilder.Append(", IsCompleted = " + IsCompleted);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            return stringBuilder.ToString();
        }
    }
}
