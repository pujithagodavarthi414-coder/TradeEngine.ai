using System;
using System.Collections.Generic;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.UserStory
{
    public class UserStoryInputModel : InputModelBase
    {
        public UserStoryInputModel() : base(InputTypeGuidConstants.UserStoryInputCommandTypeGuid)
        {
        }

        public Guid? GoalId { get; set; }
        public int? AmendBy { get; set; }

        public List<Guid> UserStoryIds { get; set; }
        public string UserStoryIdsXml { get; set; }
        public string TimeZone { get; set; }

        public decimal? EstimatedTime { get; set; }
        public Guid? UserStoryStatusId { get; set; }
        public Guid ProjectId { get; set; }
        public Guid? OwnerUserId { get; set; }
        public Guid? DependencyUserId { get; set; }

        public bool ClearEstimate { get; set; }
        public bool SetBackStatus { get; set; }
        public bool ClearOwner { get; set; }
        public bool ClearDependency { get; set; }
        public Guid? SprintId {get;set;}
        public bool? IsSprintUserstories { get; set; }
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("GoalId = " + GoalId);
            stringBuilder.Append(", UserStoryIds = " + UserStoryIds);
            stringBuilder.Append(", UserStoryIdsXml = " + UserStoryIdsXml);
            stringBuilder.Append(", EstimatedTime = " + EstimatedTime);
            stringBuilder.Append(", UserStoryStatusId = " + UserStoryStatusId);
            stringBuilder.Append(", OwnerUserId = " + OwnerUserId);
            stringBuilder.Append(", DependencyUserId = " + DependencyUserId);
            stringBuilder.Append(", ClearEstimate = " + ClearEstimate);
            stringBuilder.Append(", SetBackStatus = " + SetBackStatus);
            stringBuilder.Append(", ClearOwner = " + ClearOwner);
            stringBuilder.Append(", ClearDependency = " + ClearDependency);
            return stringBuilder.ToString();
        }
    }
}
