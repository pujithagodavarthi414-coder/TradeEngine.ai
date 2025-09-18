using System;
using System.Text;

namespace Btrak.Models.TestRail
{
    public class MilestoneOverviewModel
    {
        public Guid? MilestoneId { get; set; }

        public Guid? ProjectId { get; set; }

        public string MilestoneTitle { get; set; }

        public string Description { get; set; }
            
        public DateTime? EndDate { get; set; }

        public bool IsCompleted { get; set; }

        public bool IsArchived { get; set; }

        public bool IsStarted { get; set; }

        public int? TestRunsCount { get; set; }

        public string EndDateString { get; set; }

        public int? SubMilestoneCount { get; set; }

        public byte[] TimeStamp { get; set; }

        public int? TotalCount { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("MilestoneId = " + MilestoneId);
            stringBuilder.Append(", ProjectId = " + ProjectId);
            stringBuilder.Append(", MilestoneTitle = " + MilestoneTitle);
            stringBuilder.Append(", Description = " + Description);
            stringBuilder.Append(", EndDate = " + EndDate);
            stringBuilder.Append(", IsCompleted = " + IsCompleted);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", IsStarted = " + IsStarted);
            stringBuilder.Append(", IsCompleted = " + IsCompleted);
            stringBuilder.Append(", EndDateString = " + EndDateString);
            stringBuilder.Append(", SubMilestoneCount = " + SubMilestoneCount);
            stringBuilder.Append(", TotalCount = " + TotalCount);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            return stringBuilder.ToString();
        }
    }
}
