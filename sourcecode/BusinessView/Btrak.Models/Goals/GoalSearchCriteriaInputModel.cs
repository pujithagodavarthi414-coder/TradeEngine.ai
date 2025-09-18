using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.Goals
{
    public class GoalSearchCriteriaInputModel : SearchCriteriaInputModelBase
    {
        public GoalSearchCriteriaInputModel() : base(InputTypeGuidConstants.GoalSearchCriteriaInputCommandTypeGuid)
        {
        }
        public string GoalUniqueNumber { get; set; }
        public Guid? GoalId { get; set; }
        public Guid? UserStoryId { get; set; }
        public Guid? ProjectId { get; set; }
        public Guid? OwnerUserId { get; set; }
        public bool IsGoalsPage { get; set; }
        public bool IsAdvancedSearch { get; set; }
        public string GoalName { get; set; }
        public string GoalShortName { get; set; }
        public DateTimeOffset? DeadLineDateFrom { get; set; }
        public DateTimeOffset? DeadLineDateTo { get; set; }
        public decimal? GoalBudget { get; set; }
        public Guid? GoalResponsibleUserId { get; set; }
        public Guid? BoardTypeId { get; set; }
        public Guid? BoardTypeUiId { get; set; }
        public Guid? BoardTypeApiId { get; set; }
        public DateTimeOffset? OnboardProcessDate { get; set; }
        public bool? IsLocked { get; set; }
        public bool? IsApproved { get; set; }
        public bool? IsCompleted { get; set; }
        public DateTime? ArchivedDateTime { get; set; }
        public bool? IsParked { get; set; }
        public DateTime? ParkedDateTime { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public Guid CreatedByUserId { get; set; }
        public DateTime? UpdatedDateTime { get; set; }
        public Guid? UpdatedByUserId { get; set; }
        public Guid? GoalStatusId { get; set; }
        public string GoalStatus { get; set; }
        public string GoalStatusColor { get; set; }
        public string Version { get; set; }
        public bool? IsProductiveBoard { get; set; }
        public bool? IsToBeTracked { get; set; }
        public Guid? ConsiderEstimatedHoursId { get; set; }
        public Guid? ConfigurationId { get; set; }
        public Guid? BranchId { get; set; }
        public DateTimeOffset? DateFrom { get; set; }
        public DateTimeOffset? DateTo { get; set; }
        public bool? IsRed { get; set; }
        public bool? IsWarning { get; set; }
        public bool? IsTracked { get; set; }
        public bool? IsProductive { get; set; }
        public bool? IsArchivedGoal { get; set; }
        public Guid? UserId { get; set; }
        public Guid? UserStoryStatusId { get; set; }
        public bool? IsUserStoryArchived { get; set; }
        public bool? IsUserStoryParked { get; set; }
        public bool? IsGoalParked { get; set; }
        public bool? IncludeArchived { get; set; }
        public bool? IncludeParked { get; set; }
        public bool IsGoalsBasedOnGrp { get; set; }
        public bool IsGoalsBasedOnProject { get; set; }
        public string GoalIds { get; set; }
        public string GoalIdsXml { get; set; }
        public bool? IsBugBoard { get; set; }
        public bool? IsUnique { get; set; }
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", GoalId = " + GoalId);
            stringBuilder.Append(", UserStoryId = " + UserStoryId);
            stringBuilder.Append("ProjectId = " + ProjectId);
            stringBuilder.Append("OwnerUserId = " + OwnerUserId);
            stringBuilder.Append(", IsGoalsPage = " + IsGoalsPage);
            stringBuilder.Append(", IsAdvancedSearch = " + IsAdvancedSearch);
            stringBuilder.Append(", GoalName = " + GoalName);
            stringBuilder.Append(", GoalShortName = " + GoalShortName);
            stringBuilder.Append(", DeadLineDateFrom = " + DeadLineDateFrom);
            stringBuilder.Append(", DeadLineDateTo = " + DeadLineDateTo);
            stringBuilder.Append(", GoalBudget = " + GoalBudget);
            stringBuilder.Append(", GoalResponsibleUserId = " + GoalResponsibleUserId);
            stringBuilder.Append(", BoardTypeId = " + BoardTypeId);
            stringBuilder.Append(", BoardTypeUiId = " + BoardTypeUiId);
            stringBuilder.Append(", BoardTypeApiId = " + BoardTypeApiId);
            stringBuilder.Append(", OnboardProcessDate = " + OnboardProcessDate);
            stringBuilder.Append(", IsLocked = " + IsLocked);
            stringBuilder.Append(", IsApproved = " + IsApproved);
            stringBuilder.Append(", IsCompleted = " + IsCompleted);
            stringBuilder.Append(", ArchivedDateTime = " + ArchivedDateTime);
            stringBuilder.Append(", IsParked = " + IsParked);
            stringBuilder.Append(", ParkedDateTime = " + ParkedDateTime);
            stringBuilder.Append(", CreatedDateTime = " + CreatedDateTime);
            stringBuilder.Append(", CreatedByUserId = " + CreatedByUserId);
            stringBuilder.Append(",UpdatedDateTime = " + UpdatedDateTime);
            stringBuilder.Append(",UpdatedByUserId = " + UpdatedByUserId);
            stringBuilder.Append(", GoalStatusId = " + GoalStatusId);
            stringBuilder.Append(", GoalStatusColor = " + GoalStatusColor);
            stringBuilder.Append(", Version = " + Version);
            stringBuilder.Append(", IsProductiveBoard = " + IsProductiveBoard);
            stringBuilder.Append(", IsToBeTracked = " + IsToBeTracked);
            stringBuilder.Append(", ConsiderEstimatedHoursId = " + ConsiderEstimatedHoursId);
            stringBuilder.Append(", ConfigurationId = " + ConfigurationId);
            stringBuilder.Append(",BranchId = " + BranchId);
            stringBuilder.Append(",DateFrom = " + DateFrom);
            stringBuilder.Append(", DateTo = " + DateTo);
            stringBuilder.Append(", IsRed = " + IsRed);
            stringBuilder.Append(", IsWarning = " + IsWarning);
            stringBuilder.Append(", IsTracked = " + IsTracked);
            stringBuilder.Append(", IsProductive = " + IsProductive);
            stringBuilder.Append(", IsArchivedGoal = " + IsArchivedGoal);
            stringBuilder.Append(", UserId = " + UserId);
            stringBuilder.Append(", UserStoryStatusId = " + UserStoryStatusId);
            stringBuilder.Append(", IsUserStoryArchived = " + IsUserStoryArchived);
            stringBuilder.Append(", IsUserStoryParked = " + IsUserStoryParked);
            stringBuilder.Append(", IsGoalParked = " + IsGoalParked);
            stringBuilder.Append(", IncludeArchived = " + IncludeArchived);
            stringBuilder.Append(", IncludeParked = " + IncludeParked);
            stringBuilder.Append(", IsGoalsBasedOnGrp = " + IsGoalsBasedOnGrp);
            stringBuilder.Append(", IsGoalsBasedOnProject = " + IsGoalsBasedOnProject);
            return stringBuilder.ToString();
        }

    }
}
