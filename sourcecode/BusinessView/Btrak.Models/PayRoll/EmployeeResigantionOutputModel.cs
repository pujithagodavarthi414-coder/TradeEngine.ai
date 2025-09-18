using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.PayRoll
{
    public class EmployeeResigantionOutputModel
    {
        public Guid? EmployeeResignationId { get; set; }
        public Guid? ReportingToId { get; set; }
        public Guid? AppliedUserId { get; set; }
        public string AppliedUserName { get; set; }
        public string ApprovedOrRejectedUserName { get; set; }
    }
}
