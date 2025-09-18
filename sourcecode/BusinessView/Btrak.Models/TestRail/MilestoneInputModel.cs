using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.TestRail
{
    public class MilestoneInputModel : InputModelBase
    {
        public MilestoneInputModel() : base(InputTypeGuidConstants.MilestoneInputCommandTypeGuid)
        {
        }

        public Guid? MilestoneId { get; set; }

        public Guid? ProjectId { get; set; }

        public string MilestoneTitle { get; set; }

        public Guid? ParentMileStoneId { get; set; }

        public string Description { get; set; }

        public DateTimeOffset? StartDate { get; set; }

        public DateTimeOffset? EndDate { get; set; }

        public bool IsCompleted { get; set; }

        public bool IsArchived { get; set; }

        public bool IsStarted { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("MilestoneId = " + MilestoneId);
            stringBuilder.Append(", ProjectId = " + ProjectId);
            stringBuilder.Append(", MilestoneTitle = " + MilestoneTitle);
            stringBuilder.Append(", ParentMileStoneId = " + ParentMileStoneId);
            stringBuilder.Append(", Description = " + Description);
            stringBuilder.Append(", StartDate = " + StartDate);
            stringBuilder.Append(", EndDate = " + EndDate);
            stringBuilder.Append(", IsCompleted = " + IsCompleted);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", IsStarted = " + IsStarted);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            return stringBuilder.ToString();
        }
    }
}
