using System;

namespace Btrak.Models.PayRoll
{
   public class PayRollStatus
    {
        public Guid? Id { get; set; }
        public string PayRollStatusName { get; set; }
        public bool IsArchived { get; set; }

        public Guid? PayrollRunId { get; set; }
        public Guid? WorkflowProcessInstanceId { get; set; }
        public string Comments { get; set; }
        public bool IsPayslipReleased { set; get; }

    }
   
}
