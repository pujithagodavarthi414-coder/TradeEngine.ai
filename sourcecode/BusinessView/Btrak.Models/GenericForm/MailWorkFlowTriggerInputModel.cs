using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.GenericForm
{
    public class MailWorkFlowTriggerInputModel
    {
        public string Tomails { get; set; }   
        public string Ccmails { get; set; }   // No need for now
        public string WorkflowIds { get; set; }
        public Guid? CustomApplicationId { get; set; }
        public Guid? FormId { get; set; }
        public Guid? SubmittedId { get; set; }
    }
}
