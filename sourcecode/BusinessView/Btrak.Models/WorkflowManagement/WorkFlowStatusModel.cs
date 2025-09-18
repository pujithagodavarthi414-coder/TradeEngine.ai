using System;

namespace Btrak.Models.WorkflowManagement
{
    public class GenericStatusModel
    {
        public Guid? WorkFlowId { get; set; }
        public string Status { get; set; }
        public string StatusColor { get; set; }
        public Guid? GenericStatusId { get; set; }
        public Guid? ReferenceId { get; set; }
        public Guid? ReferenceTypeId { get; set; }
        public dynamic Answer { get; set; }
    }
}
