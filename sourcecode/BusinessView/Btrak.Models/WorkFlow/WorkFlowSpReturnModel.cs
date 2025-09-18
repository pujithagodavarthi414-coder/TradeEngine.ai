using System;

namespace Btrak.Models.WorkFlow
{
    public class WorkFlowSpReturnModel
    {
        public Guid? WorkFlowId { get; set; }
        public string WorkflowName { get; set; }
        public bool IsArchived { get; set; }

        public DateTimeOffset CreatedDatetime { get; set; }
        public int TotalCount { get; set; }

        public Guid? CompanyId { get; set; }

        public Guid? CreatedByUserId { get; set; }
        public Guid? UpdatedByUserId { get; set; }
        public DateTimeOffset UpdatedDateTime { get; set; }
        public byte[] TimeStamp { get; set; }


    }
}
