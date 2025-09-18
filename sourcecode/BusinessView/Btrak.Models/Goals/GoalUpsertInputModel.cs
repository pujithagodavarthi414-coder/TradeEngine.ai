using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.Goals
{
    public class GoalUpsertInputModel : InputModelBase
    {
        public GoalUpsertInputModel() : base(InputTypeGuidConstants.GoalUpsertInputCommandTypeGuid)
        {
        }

        public Guid? ProjectId { get; set; }

        public Guid? GoalId { get; set; }
        public string GoalName { get; set; }
        public string GoalShortName { get; set; }

        public decimal? GoalBudget { get; set; }
        public Guid? GoalResponsibleUserId { get; set; }

        public Guid? BoardTypeId { get; set; }
        public Guid? BoardTypeApiId { get; set; }
        public string GoalStatusColor { get; set; }
        public string TimeZone { get; set; }

        public DateTimeOffset? OnboardProcessDate { get; set; }
        public int TimeZoneOffset { get; set; }

        public bool IsArchived { get; set; }
        public bool? IsLocked { get; set; }
        public bool? IsApproved { get; set; }
        public bool? IsParked { get; set; }
        public bool? IsCompleted { get; set; }

        public string Version { get; set; }

        public bool? IsProductiveBoard { get; set; }
        public bool? IsToBeTracked { get; set; }

        public Guid? ConsiderEstimatedHoursId { get; set; }
        public Guid? ConfigurationId { get; set; }
        public Guid? TestSuiteId { get; set; }

        public string Description { get; set; }
        public bool? IsEdit { get; set; }
        public DateTimeOffset? EndDate { get; set; }
        public decimal? EstimatedTime { get; set; }
        public decimal? GoalEstimateTime { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("ProjectId = " + ProjectId);
            stringBuilder.Append(", GoalId = " + GoalId);
            stringBuilder.Append(", GoalName = " + GoalName);
            stringBuilder.Append(", GoalShortName = " + GoalShortName);
            stringBuilder.Append(", BoardTypeId = " + BoardTypeId);
            stringBuilder.Append(", BoardTypeApiId = " + BoardTypeApiId);
            stringBuilder.Append(", OnboardProcessDate = " + OnboardProcessDate);
            stringBuilder.Append(", GoalResponsibleUserId = " + GoalResponsibleUserId);
            stringBuilder.Append(", ConfigurationId = " + ConfigurationId);
            stringBuilder.Append(", IsToBeTracked = " + IsToBeTracked);
            stringBuilder.Append(", IsProductiveBoard = " + IsProductiveBoard);
            stringBuilder.Append(", ConsiderEstimatedHoursId = " + ConsiderEstimatedHoursId);
            stringBuilder.Append(", IsApproved = " + IsApproved);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", IsLocked = " + IsLocked);
            stringBuilder.Append(", IsParked = " + IsParked);
            stringBuilder.Append(", GoalBudget = " + GoalBudget);
            stringBuilder.Append(", Version = " + Version);
            stringBuilder.Append(", IsCompleted = " + IsCompleted);
            stringBuilder.Append(", TestSuiteId = " + TestSuiteId);
            stringBuilder.Append(", Description = " + Description);
            stringBuilder.Append(", EndDate = " + EndDate);
            stringBuilder.Append(", EstimatedTime = " + EstimatedTime);
            return stringBuilder.ToString();
        }
    }
}