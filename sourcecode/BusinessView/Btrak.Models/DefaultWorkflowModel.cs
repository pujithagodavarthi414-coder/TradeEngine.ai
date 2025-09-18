using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models
{
     public class DefaultWorkflowModel
    {
        public Guid? AuditDefaultWorkflowId { get; set; }
        public Guid? ConductDefaultWorkflowId { get; set; }
        public Guid? QuestionDefaultWorkflowId { get; set; }
    }
}
