using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.UserStory
{
    public class AdhocWorkApiReturnModel
    {
        public string UserStoryName { get; set; }
        public string ProjectName { get; set; }
        public string GoalName { get; set; }
        public string SprintName { get; set; }
        public string DependencyName { get; set; }
        public string OwnerName { get; set; }
        public decimal? EstimatedTime { get; set; }
        public DateTimeOffset? DeadLineDate { get; set; }
        public int TotalCount { get; set; }
        public string UserStoryTypeName { get; set; }
        public string UserStoryTypeColor { get; set; }
        public Guid? OwnerUserId { get; set; }
        public string ProfileImage { get; set; }
        public string TimeZoneName { get; set; }
        public string TimeZoneAbbreviation { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", UserStoryName = " + UserStoryName);
            stringBuilder.Append(", ProjectName = " + ProjectName);
            stringBuilder.Append(", GoalName = " + GoalName);
            stringBuilder.Append(", DependencyName = " + DependencyName);
            stringBuilder.Append(", OwnerName = " + OwnerName);
            stringBuilder.Append(", EstimatedTime = " + EstimatedTime);
            stringBuilder.Append(", DeadLineDate = " + DeadLineDate);
            stringBuilder.Append(", TotalCount = " + TotalCount);
            return stringBuilder.ToString();
        }
    }
}
