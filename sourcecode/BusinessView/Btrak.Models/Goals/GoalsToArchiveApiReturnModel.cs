using System;
using System.Text;

namespace Btrak.Models.Goals
{
    public class GoalsToArchiveApiReturnModel
    {
        public Guid? ProjectId { get; set; }
        public string ProjectName { get; set; }
        public string ProjectStatusColor { get; set; }
        public Guid? ProjectResponsiblePersonId { get; set; }
        public Guid GoalStatusId { get; set; }
        public string GoalStatusName { get; set; }
        public bool? GoalStatusIsArchived { get; set; }
        public Guid? ConfigurationTypeId { get; set; }
        public string ConfigurationTypeName { get; set; }
        public DateTime? ConfigurationTypeArchivedDateTime { get; set; }
        public Guid? UserId { get; set; }
        public string UserName { get; set; }
        public string UserProfileImage { get; set; }
        public string ConsiderHoursName { get; set; }
        public Guid? GoalId { get; set; }
        public string GoalName { get; set; }
        public string GoalShortName { get; set; }
        public string GoalStatusColor { get; set; }
        public bool GoalIsArchived { get; set; }
        public Guid? BoardTypeId { get; set; }
        public string BoardTypeName { get; set; }
        public Guid? BoardTypeUiId { get; set; }
        public bool BoardTypeIsArchived { get; set; }
        public decimal? GoalBudget { get; set; }
        public Guid? GoalResponsibleUserId { get; set; }
        public string GoalResponsibleUserName { get; set; }
        public DateTime? OnboardProcessDate { get; set; }
        public DateTime? GoalDeadLineDate { get; set; }
        public bool? IsWarning { get; set; }
        public Guid? BoardTypeApiId { get; set; }
        public bool? IsLocked { get; set; }
        public bool? IsApproved { get; set; }
        public bool? IsParked { get; set; }
        public DateTime? ParkedDateTime { get; set; }
        public DateTime CreatedDateTime { get; set; }
      
        public Guid? ConsiderEstimatedHoursId { get; set; }
        public int UserStoriesCount { get; set; }
        public string Version { get; set; }
        public bool? IsProductiveBoard { get; set; }
        public bool? IsToBeTracked { get; set; }
        public Guid? ConsiderHoursId { get; set; }
        public string ConsiderHourName { get; set; }
        public Guid? ConfigurationId { get; set; }
        public string FirstName { get; set; }
        public string SurName { get; set; }
        public string ProfileImage { get; set; }
        public Guid? RoleId { get; set; }
        public int? TotalCount { get; set; }

        public override string ToString()
        {

            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("ProjectId = " + ProjectId);
            stringBuilder.Append(", ProjectName = " + ProjectName);
            stringBuilder.Append(", ProjectStatusColor = " + ProjectStatusColor);
            stringBuilder.Append(", ProjectResponsiblePersonId = " + ProjectResponsiblePersonId);
            stringBuilder.Append(", GoalId = " + GoalId);
            stringBuilder.Append(", GoalName = " + GoalName);
            stringBuilder.Append(", GoalShortName = " + GoalShortName);
            stringBuilder.Append(", GoalBudget = " + GoalBudget);
            stringBuilder.Append(", GoalResponsibleUserId = " + GoalResponsibleUserId);
            stringBuilder.Append(", GoalResponsibleUserName = " + GoalResponsibleUserName);
            stringBuilder.Append(", OnboardProcessDate = " + OnboardProcessDate);
            stringBuilder.Append(", GoalDeadLineDate = " + GoalDeadLineDate);
            stringBuilder.Append(", IsWarning = " + IsWarning);
            stringBuilder.Append(", BoardTypeId = " + BoardTypeId);
            stringBuilder.Append(", BoardTypeName = " + BoardTypeName);
            stringBuilder.Append(", BoardTypeUiId = " + BoardTypeUiId);
            stringBuilder.Append(", BoardTypeApiId = " + BoardTypeApiId);
            stringBuilder.Append(", IsLocked = " + IsLocked);
            stringBuilder.Append(", IsApproved = " + IsApproved);
            stringBuilder.Append(", IsParked = " + IsParked);
            stringBuilder.Append(", GoalStatusId = " + GoalStatusId);
            stringBuilder.Append(", GoalStatusName = " + GoalStatusName);
            stringBuilder.Append(", GoalStatusColor = " + GoalStatusColor);
            stringBuilder.Append(", Version = " + Version);
            stringBuilder.Append(", IsProductiveBoard = " + IsProductiveBoard);
            stringBuilder.Append(", IsToBeTracked = " + IsToBeTracked);
            stringBuilder.Append(", ConsiderEstimatedHoursId = " + ConsiderEstimatedHoursId);
            stringBuilder.Append(", ConsiderHoursName = " + ConsiderHoursName);
            stringBuilder.Append(", ConfigurationId = " + ConfigurationId);
            stringBuilder.Append(", ConfigurationTypeName = " + ConfigurationTypeName);
            stringBuilder.Append(", UserStoriesCount = " + UserStoriesCount);
            stringBuilder.Append(", TotalCount = " + TotalCount);
            stringBuilder.Append(", GoalStatusIsArchived = " + GoalStatusIsArchived);
            stringBuilder.Append(", ConfigurationTypeArchivedDateTime = " + ConfigurationTypeArchivedDateTime);
            stringBuilder.Append(", UserProfileImage = " + UserProfileImage);
            stringBuilder.Append(", ConsiderHoursId = " + ConsiderHoursId);
            stringBuilder.Append(", GoalIsArchived = " + GoalIsArchived);
            stringBuilder.Append(", BoardTypeIsArchived = " + BoardTypeIsArchived);
        
            stringBuilder.Append(", UserId = " + UserId);
            stringBuilder.Append(", FirstName = " + FirstName);
            stringBuilder.Append(", SurName = " + SurName);
            stringBuilder.Append(", UserName = " + UserName);
            stringBuilder.Append(", ProfileImage = " + ProfileImage);
            stringBuilder.Append(", RoleId = " + RoleId);
            return stringBuilder.ToString();
        }
    }
}
