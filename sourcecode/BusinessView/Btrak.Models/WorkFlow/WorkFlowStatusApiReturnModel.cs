using System;
using System.Text;

namespace Btrak.Models.WorkFlow
{
    public class WorkFlowStatusApiReturnModel
    {
        public Guid? WorkFlowStatusId { get; set; }

        public Guid? WorkFlowId { get; set; }
        public string WorkflowName { get; set; }

        public Guid? UserStoryStatusId { get; set; }
        public string UserStoryStatusName { get; set; }
        public string UserStoryStatusColor { get; set; }
        public bool CanAdd { get; set; }
        public bool CanDelete { get; set; }
        public int? OrderId { get; set; }
        public bool? IsCompleted { get; set; }
        public int? MaxOrder { get; set; }
        public bool? IsBlocked { get; set; }
        public bool IsArchived { get; set; }

        public Guid? TaskStatusId { get; set; }
        public int TotalCount { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public DateTimeOffset CreatedDateTime { get; set; }
        public Guid? UpdatedByUserId { get; set; }
        public DateTimeOffset? UpdatedDateTime { get; set; }
        public Guid? CompanyId { get; set; }
        public byte[]  TimeStamp {get;set;}

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("WorkFlowStatusId = " + WorkFlowStatusId);
            stringBuilder.Append(", WorkFlowId = " + WorkFlowId);
            stringBuilder.Append(", WorkflowName = " + WorkflowName);
            stringBuilder.Append(", OrderId = " + OrderId);
            stringBuilder.Append(", IsCompleted = " + IsCompleted);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", IsBlocked = " + IsBlocked);
            stringBuilder.Append(", UserStoryStatusId = " + UserStoryStatusId);
            stringBuilder.Append(", UserStoryStatusName = " + UserStoryStatusName);
            stringBuilder.Append(", UserStoryStatusColor = " + UserStoryStatusColor);
            stringBuilder.Append(", CreatedByUserId = " + CreatedByUserId);
            stringBuilder.Append(", CreatedDateTime = " + CreatedDateTime);
            stringBuilder.Append(", UpdatedByUserId = " + UpdatedByUserId);
            stringBuilder.Append(", UpdatedDateTime = " + UpdatedDateTime);
            stringBuilder.Append(", CompanyId = " + CompanyId);
            stringBuilder.Append(", TotalCount = " + TotalCount);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            return stringBuilder.ToString();
        }
    }
}
