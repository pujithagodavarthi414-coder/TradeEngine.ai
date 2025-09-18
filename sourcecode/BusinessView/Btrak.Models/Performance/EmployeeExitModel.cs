using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.Performance
{
    public class EmployeeExitModel
    {
        public string ExitName { get; set; }
        public Guid? AssignedToId { get; set; }
        public string AssignedToName { get; set; }
        public string AssignedToImage { get; set; }
        public string Status { get; set; }

        public Guid? UserId { get; set; }
    }
}
