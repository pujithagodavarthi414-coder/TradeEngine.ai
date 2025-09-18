using System;

namespace Btrak.Models.WorkFlow
{
    public class WorkFlowModel
    {
        public Guid? WorkFlowId { get; set; }
        public string WorkFlowName { get; set; }
        public bool IsArchived { get; set; }
    }
}
