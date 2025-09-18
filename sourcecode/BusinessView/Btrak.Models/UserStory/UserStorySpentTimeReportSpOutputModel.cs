using System;
using BTrak.Common;

namespace Btrak.Models.UserStory
{
    public class UserStorySpentTimeReportSpOutputModel : InputModelBase
    {
        public UserStorySpentTimeReportSpOutputModel() : base(InputTypeGuidConstants.UserStorySpentTimeReportCommandTypeGuid)
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
    }
}
