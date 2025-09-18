using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.TestRail
{
    public class MilestoneSearchCriteriaInputModel : SearchCriteriaInputModelBase
    {
        public MilestoneSearchCriteriaInputModel() : base(InputTypeGuidConstants.MilestoneSearchCriteriaInputCommandTypeGuid)
        {
        }

        public Guid? MilestoneId { get; set; }

        public Guid? ProjectId { get; set; }

        public string Title { get; set; }

        public Guid? ParentMileStoneId { get; set; }

        public string Description { get; set; }

        public DateTimeOffset? StartDate { get; set; }

        public DateTimeOffset? EndDate { get; set; }

        public bool? IsCompleted { get; set; }

        public bool IsForDropdown { get; set; }

        public bool? IsStarted { get; set; }

        public DateTime? DateFrom { get; set; }

        public DateTime? DateTo { get; set; }


        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("MilestoneId = " + MilestoneId);
            stringBuilder.Append(", ProjectId = " + ProjectId);
            stringBuilder.Append(", Title = " + Title);
            stringBuilder.Append(", ParentMileStoneId = " + ParentMileStoneId);
            stringBuilder.Append(", Description = " + Description);
            stringBuilder.Append(", StartDate = " + StartDate);
            stringBuilder.Append(", EndDate = " + EndDate);
            stringBuilder.Append(", IsCompleted = " + IsCompleted);
            stringBuilder.Append(", IsForDropdown = " + IsForDropdown);
            stringBuilder.Append(", IsStarted = " + IsStarted);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            stringBuilder.Append(", DateFrom = " + DateFrom);
            stringBuilder.Append(", DateTo = " + DateTo);
            return stringBuilder.ToString();
        }
    }
}
