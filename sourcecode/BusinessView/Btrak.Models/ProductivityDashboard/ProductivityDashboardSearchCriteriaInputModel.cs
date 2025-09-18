using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.ProductivityDashboard
{
    public class ProductivityDashboardSearchCriteriaInputModel : SearchCriteriaInputModelBase
    {
        public ProductivityDashboardSearchCriteriaInputModel() : base(InputTypeGuidConstants.ProductivityDashboardSearchCriteriaInputCommandTypeGuid)
        {
        }

        public string Type { get; set; }
        public DateTime? SelectedDate { get; set; }
        public DateTime? DateFrom { get; set; }
        public DateTime? DateTo { get; set; }
        public Guid? ProjectId { get; set; }
        public Guid? AssigneeId { get; set; }
        public Guid? ProjectFeatureId { get; set; }
        public bool ShowGoalLevel { get; set; }
        public bool IsUserstoryOutsideQa { get; set; }
        public DateTime? DeadLineDateFrom { get; set; }
        public DateTime? DeadLineDateTo { get; set; }
        public Guid? UserStoryStatusId { get; set; }
        public Guid? OwnerUserId { get; set; }
        public Guid? EntityId { get; set; }
        public string IndexType { get; set; }
        public bool IsReportingOnly { get; set; }
        public bool IsAll { get; set; }
        public bool IsMyself { get; set; }
        public bool? IsFromDrilldown { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("Type = " + Type);
            stringBuilder.Append(", SelectedDate = " + SelectedDate);
            stringBuilder.Append(", ProjectId = " + ProjectId);
            stringBuilder.Append(", AssigneeId = " + AssigneeId);
            stringBuilder.Append(", ProjectFeatureId = " + ProjectFeatureId);
            stringBuilder.Append(", ShowGoalLevel = " + ShowGoalLevel);
            stringBuilder.Append(", IsUserstoryOutsideQa = " + IsUserstoryOutsideQa);
            stringBuilder.Append(", DeadLineDateFrom = " + DeadLineDateFrom);
            stringBuilder.Append(", DeadLineDateTo = " + DeadLineDateTo);
            stringBuilder.Append(", UserStoryStatusId = " + UserStoryStatusId);
            stringBuilder.Append(", OwnerUserId = " + OwnerUserId);
            stringBuilder.Append(", EntityId = " + EntityId);
            stringBuilder.Append(", IsReportingOnly = " + IsReportingOnly);
            stringBuilder.Append(", IsAll = " + IsAll);
            stringBuilder.Append(", IsMyself = " + IsMyself);
            return stringBuilder.ToString();
        }
    }
}
