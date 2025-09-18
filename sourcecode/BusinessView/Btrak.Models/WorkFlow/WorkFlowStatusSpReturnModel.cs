using System;

namespace Btrak.Models.WorkFlow
{
    public class WorkFlowStatusSpReturnModel
    {
        public Guid? WorkflowStatusId { get; set; }

        public Guid? WorkflowId { get; set; }
        public string WorkflowName { get; set; }

        public Guid? UserStoryStatusId { get; set; }
        public string UserStoryStatusName { get; set; }
        public string UserStoryStatusColor { get; set; }

        public int? OrderId { get; set; }
        public bool? IsCompleted { get; set; }
        /* IsActive means IsArchived because in db this field as IsActive */
        public bool IsArchived { get; set; }
        public bool? IsBlocked { get; set; }
        public byte[] TimeStamp { get; set; }
        public int TotalCount { get; set; }
        public Guid? CreatedByUserId{get;set;}
        public DateTime CreatedDateTime { get; set; }
        public Guid? UpdatedByUserId { get; set; }
        public DateTime UpdatedDateTime { get; set; }
        public Guid? CompanyId { get; set; }
    }
}