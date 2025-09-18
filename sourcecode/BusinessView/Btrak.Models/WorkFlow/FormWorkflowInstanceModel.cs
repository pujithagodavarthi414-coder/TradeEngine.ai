using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.WorkFlow
{
    public class FormWorkflowInstanceModel
    {
        public string ProcessInstanceId { get; set; }
        public Guid? FormSubmittedId { get; set; }
        public Guid Id { get; set; }
    }
}
