using System;
using System.Collections.Generic;
using System.Text;

namespace Btrak.Models.UserStory
{
    public class GetBugsBasedOnUserStoryApiReturnModel
    {
        public bool IsArchived { get; set; }
        public DateTimeOffset? ArchivedDateTime { get; set; }
        public DateTimeOffset? ParkedDateTime { get; set; }
        public Guid? UserStoryId { get; set; }
        public Guid? UserStoryStatusId { get; set; }
        public Guid? GoalId { get; set; }
        public Guid? AuditConductQuestionId { get; set; }
        public string UserStoryName { get; set; }
        public string OwnerName { get; set; }
        public string UserStoryUniqueName { get; set; }
        public string BugPriorityName { get; set; }
        public string BugPriorityIcon { get; set; }
        public string BugPriorityColor { get; set; }
        public string Status { get; set; }
        public string StatusHexValue { get; set; }
        public string BugPriorityDescription { get; set; }
        public DateTimeOffset CreatedDateTime { get; set; }
        public DateTimeOffset? DeadLineDate { get; set; }
        public int TotalCount { get; set; }
        public Guid? ParentUserStoryId { get; set; }
        public byte[] TimeStamp { get; set; }
        public Guid? TestCaseId { get; set; }
        public Guid GoalStatusId { get; set; }
        public bool? IsReplan { get; set; }
        public DateTime? SprintStartDate { get; set; }
        public Guid? WorkFlowId { get; set; }
        public Guid? OwnerUserId { get; set; }
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", ArchivedDateTime = " + ArchivedDateTime);
            stringBuilder.Append(", CreatedDateTime = " + CreatedDateTime);
            stringBuilder.Append(", DeadLineDate = " + DeadLineDate);
            stringBuilder.Append(", UserStoryId = " + UserStoryId);
            stringBuilder.Append(", GoalId = " + GoalId);
            stringBuilder.Append(", Status = " + Status);
            stringBuilder.Append(", StatusHexValue = " + StatusHexValue);
            stringBuilder.Append(", UserStoryStatusId = " + UserStoryStatusId);
            stringBuilder.Append(", ParentUserStoryId = " + ParentUserStoryId);
            stringBuilder.Append(", UserStoryName = " + UserStoryName);
            stringBuilder.Append(", OwnerName = " + OwnerName);
            stringBuilder.Append(", UserStoryUniqueName = " + UserStoryUniqueName);
            stringBuilder.Append(", BugPriorityName = " + BugPriorityName);
            stringBuilder.Append(", BugPriorityIcon = " + BugPriorityIcon);
            stringBuilder.Append(", BugPriorityColor = " + BugPriorityColor);
            stringBuilder.Append(", BugPriorityDescription = " + BugPriorityDescription);
            
            return stringBuilder.ToString();
        }
    }
}
