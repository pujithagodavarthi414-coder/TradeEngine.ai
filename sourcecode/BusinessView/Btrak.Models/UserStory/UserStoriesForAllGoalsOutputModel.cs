using System;
using System.Collections.Generic;
using System.Text;
using Btrak.Models.EntityType;

namespace Btrak.Models.UserStory
{
    public class UserStoriesForAllGoalsOutputModel
    {
        public UserStoriesForAllGoalsOutputModel()
        {
           
        }

        public Guid? GoalId { get; set; }
        public Guid? ProjectId { get; set; }
        public string ProjectName { get; set; }
        public Guid? ProjectResponsiblePersonId { get; set; }
        public Guid? BoardTypeId { get; set; }
        public Guid? BoardTypeApiId { get; set; }
        public DateTimeOffset? GoalDeadLine { get; set; }
        public DateTimeOffset? GoalArchivedDateTime { get; set; }
        public DateTimeOffset? InActiveDateTime { get; set; }
        public string GoalBudget { get; set; }
        public string GoalName { get; set; }
        public Guid? GoalStatusId { get; set; }
        public Guid? TestSuiteId { get; set; }
        public string TestSuiteName { get; set; }
        public string GoalShortName { get; set; }
        public string GoalStatusColor { get; set; }
        public bool? GoalIsArchived { get; set; }
        public bool? IsLocked { get; set; }
        public bool? IsWarning { get; set; }
        public bool? IsProductiveBoard { get; set; }
        public bool? IsToBeTracked { get; set; }
        public DateTimeOffset? OnboardProcessDate { get; set; }
        public bool? GoalIsParked { get; set; }
        public bool? IsApproved { get; set; }
        public bool? IsBugBoard { get; set; }
        public bool? IsSuperAgileBoard { get; set; }
        public bool? IsDefault { get; set; }
        public DateTimeOffset? ParkedDateTime { get; set; }
        public string Version { get; set; }
        public Guid? GoalResponsibleUserId { get; set; }
        public string GoalResponsibleUserName { get; set; }
        public string GoalResponsibleProfileImage { get; set; }
        public string ProfileImage { get; set; }
        public Guid? ConfigurationId { get; set; }
        public Guid? ConsiderEstimatedHoursId { get; set; }
        public DateTimeOffset? CreatedDateTime { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public string BoardTypeName { get; set; }
        public Guid? WorkFlowId { get; set; }
        public string WorkFlowName { get; set; }
        public int? ActiveUserStoryCount { get; set; }
        public decimal? GoalEstimatedTime { get; set; }
        public Guid? WorkflowId { get; set; }
        public int? TotalCount { get; set; }

        public int? WorkItemsCount { get; set; }
        public Guid? BoardTypeUiId { get; set; }
        public string GoalResponsibleUserFullName { get; set; }
        public Byte[] TimeStamp { get; set; }
        public string GoalUniqueName { get; set; }
        public string SubUserStories { get; set; }
        public bool? IsDateTimeConfiguration { get; set; }
        public bool IsEnableTestRepo { get; set; }
        public string Tag { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", GoalId = " + GoalId);
            stringBuilder.Append(", ProjectId = " + ProjectId);
            stringBuilder.Append(", ProjectName = " + ProjectName);
            stringBuilder.Append(", ProjectResponsiblePersonId = " + ProjectResponsiblePersonId);
            stringBuilder.Append(", BoardTypeId = " + BoardTypeId);
            stringBuilder.Append(", BoardTypeApiId = " + BoardTypeApiId);
            stringBuilder.Append(", GoalArchivedDateTime = " + GoalArchivedDateTime);
            stringBuilder.Append(", GoalBudget = " + GoalBudget);
            stringBuilder.Append(", GoalName = " + GoalName);
            stringBuilder.Append(", GoalStatusId = " + GoalStatusId);
            stringBuilder.Append(", WorkItemsCount = " + WorkItemsCount);
            stringBuilder.Append(", GoalShortName = " + GoalShortName);
            stringBuilder.Append(", GoalStatusColor = " + GoalStatusColor);
            stringBuilder.Append(", GoalIsArchived = " + GoalIsArchived);
            stringBuilder.Append(", IsLocked = " + IsLocked);
            stringBuilder.Append(", IsProductiveBoard = " + IsProductiveBoard);
            stringBuilder.Append(", IsToBeTracked = " + IsToBeTracked);
            stringBuilder.Append(", OnboardProcessDate = " + OnboardProcessDate);
            stringBuilder.Append(", GoalIsParked = " + GoalIsParked);
            stringBuilder.Append(", IsApproved = " + IsApproved);
            stringBuilder.Append(", ParkedDateTime = " + ParkedDateTime);
            stringBuilder.Append(", Version = " + Version);
            stringBuilder.Append(", GoalResponsibleUserId = " + GoalResponsibleUserId);
            stringBuilder.Append(", GoalResponsibleUserName = " + GoalResponsibleUserName);
            stringBuilder.Append(", ProfileImage = " + ProfileImage);
            stringBuilder.Append(", ConfigurationId = " + ConfigurationId);
            stringBuilder.Append(", ConsiderEstimatedHoursId = " + ConsiderEstimatedHoursId);
            stringBuilder.Append(", CreatedDateTime = " + CreatedDateTime);
            stringBuilder.Append(", CreatedByUserId = " + CreatedByUserId);
            stringBuilder.Append(", BoardTypeName = " + BoardTypeName);
            stringBuilder.Append(", WorkFlowId = " + WorkFlowId);
            stringBuilder.Append(", WorkFlowName = " + WorkFlowName);
            stringBuilder.Append(", ActiveUserStoryCount = " + ActiveUserStoryCount);
            stringBuilder.Append(", TotalCount = " + TotalCount);
            return stringBuilder.ToString();
        }
    }
}
