using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using BTrak.Common;

namespace Btrak.Models.UserStory
{
    public class UserStorySpentTimeReportApiOutputModel : InputModelBase
    {
        public UserStorySpentTimeReportApiOutputModel() : base(InputTypeGuidConstants.UserStorySpentTimeReportCommandTypeGuid)
        {
        }
        public Guid? ProjectId { get; set; }
        public string ProjectName { get; set; }
        public DateTime LoggedDate { get; set; }
        public Guid? UserId { get; set; }
        public string UserName { get; set; }
        public Guid? UserStoryTypeId { get; set; }
        public string UserStoryTypeName { get; set; }
        public Guid? UserStoryId { get; set; }
        public string UserStoryName { get; set; }
        public string Comment { get; set; }
        public int? TotalLoggedHours { get; set; }
        public int? LoggedHours { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", ProjectId = " + ProjectId);
            stringBuilder.Append(", ProjectName = " + ProjectName);
            stringBuilder.Append(", LoggedDate = " + LoggedDate);
            stringBuilder.Append(", UserId = " + UserId);
            stringBuilder.Append(", UserName = " + UserName);
            stringBuilder.Append(", UserStoryTypeId = " + UserStoryTypeId);
            stringBuilder.Append(", UserStoryTypeName = " + UserStoryTypeName);
            stringBuilder.Append(", UserStoryId = " + UserStoryId);
            stringBuilder.Append(", UserStoryName = " + UserStoryName);
            stringBuilder.Append(", Comment = " + Comment);
            stringBuilder.Append(", TotalLoggedHours = " + TotalLoggedHours);
            stringBuilder.Append(", LoggedHours = " + LoggedHours);
            return stringBuilder.ToString();
        }
    }
}

