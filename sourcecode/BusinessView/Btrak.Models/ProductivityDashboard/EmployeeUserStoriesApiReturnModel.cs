using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.ProductivityDashboard
{
    public class EmployeeUserStoriesApiReturnModel
    {
        public string OwnerName { get; set; }
        public string UserStoryName { get; set; }
        public decimal? EstimatedTime { get; set; }
        public DateTimeOffset? DeadLineDate { get; set; }
        public string UserStoryStatusName { get; set; }
        public string TimeZoneName { get; set; }
        public string TimeZoneAbbreviation { get; set; }
        public int TotalCount { get; set; }
        public Guid? OwnerUserId { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("OwnerName = " + OwnerName);
            stringBuilder.Append("UserStoryName = " + UserStoryName);
            stringBuilder.Append("EstimatedTime = " + EstimatedTime);
            stringBuilder.Append("DeadLineDate = " + DeadLineDate);
            stringBuilder.Append("UserStoryStatusName = " + UserStoryStatusName);
            stringBuilder.Append("TotalCount = " + TotalCount);
            stringBuilder.Append("OwnerUserId = " + OwnerUserId);
            stringBuilder.Append("TimeZoneName = " + TimeZoneName);
            stringBuilder.Append("TimeZoneAbbreviation = " + TimeZoneAbbreviation);
            return stringBuilder.ToString();
        }
    }
}
