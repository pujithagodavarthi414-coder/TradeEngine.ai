using System;
using System.Collections.Generic;
using System.Text;

namespace Btrak.Models.TestRail
{
    public class MilestoneApiReturnModel : ReportModel
    {
        public Guid? MilestoneId { get; set; }

        public Guid? ProjectId { get; set; }

        public string MilestoneTitle { get; set; }

        public Guid? ParentMileStoneId { get; set; }

        public string ParentMilestoneTitle { get; set; }

        public string Description { get; set; }

        public DateTimeOffset? StartDate { get; set; }

        public DateTimeOffset? EndDate { get; set; }

        public string StartDateString { get; set; }

        public bool IsArchived { get; set; }

        public bool IsCompleted { get; set; }

        public int? TestRunsCount { get; set; }

        public string EndDateString { get; set; }

        public int? SubMilestoneCount { get; set; }

        public string SubMilestonesXml { get; set; }

        public string CreatedByName { get; set; }

        public string CreatedByProfileImage { get; set; }

        public DateTime CreatedDateTime { get; set; }

        public List<MilestoneApiReturnModel> SubMilestones { get; set; }

        public string TestRunsXml { get; set; }

        public List<TestRunAndPlansOverviewModel> TestRuns { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("MilestoneId = " + MilestoneId);
            stringBuilder.Append(", ProjectId = " + ProjectId);
            stringBuilder.Append(", MilestoneTitle = " + MilestoneTitle);
            stringBuilder.Append(", ParentMileStoneId = " + ParentMileStoneId);
            stringBuilder.Append(", ParentMilestoneTitle = " + ParentMilestoneTitle);
            stringBuilder.Append(", Description = " + Description);
            stringBuilder.Append(", StartDate = " + StartDate);
            stringBuilder.Append(", EndDate = " + EndDate);
            stringBuilder.Append(", IsCompleted = " + IsCompleted);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            stringBuilder.Append(", TestRunsCount = " + TestRunsCount);
            stringBuilder.Append(", EndDateString = " + EndDateString);
            stringBuilder.Append(", SubMilestoneCount = " + SubMilestoneCount);
            stringBuilder.Append(", CreatedByName = " + CreatedByName);
            stringBuilder.Append(", CreatedByProfileImage = " + CreatedByProfileImage);
            stringBuilder.Append(", CreatedDateTime = " + CreatedDateTime);
            stringBuilder.Append(", TotalCount = " + TotalCount);
            return stringBuilder.ToString();
        }
    }
}
