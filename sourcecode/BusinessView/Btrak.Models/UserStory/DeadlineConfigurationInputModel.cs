using System;
using System.Collections.Generic;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.UserStory
{
    public class DeadlineConfigurationInputModel : InputModelBase
    {
        public DeadlineConfigurationInputModel() : base(InputTypeGuidConstants.UserStoryInputCommandTypeGuid)
        {
        }

        public Guid? GoalId { get; set; }
        public List<Guid> UserStoryIds { get; set; }
        public string UserStoryIdsXml { get; set; }
        public decimal? WorkingHoursPerDay { get; set; }
        public DateTime? SelectedDate { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("GoalId = " + GoalId);
            stringBuilder.Append(", UserStoryIds = " + UserStoryIds);
            stringBuilder.Append(", UserStoryIdsXml = " + UserStoryIdsXml);
            stringBuilder.Append(", WorkingHoursPerDay = " + WorkingHoursPerDay);
            stringBuilder.Append(", SelectedDate = " + SelectedDate);
            return stringBuilder.ToString();
        }
    }
}
