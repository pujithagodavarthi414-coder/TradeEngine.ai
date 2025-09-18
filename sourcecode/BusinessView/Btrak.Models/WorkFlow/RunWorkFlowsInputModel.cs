using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.WorkFlow
{
    public class RunWorkFlowsInputModel
    {
        public Guid? GenericFormSubmittedId { get; set; }
        public string Action { get; set; }      
    }
}
