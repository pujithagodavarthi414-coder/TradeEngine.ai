using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.MasterData
{
    public class ReportingMembersDetailsModel
    {
        public Guid? ChildId { get; set; }
        public DateTime JoinedDate { get; set; }
        public string Name { get; set; }
    }
}
