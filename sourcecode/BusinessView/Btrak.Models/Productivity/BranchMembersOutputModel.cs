using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.Productivity
{
   public class BranchMembersOutputModel
    {
        public Guid UserId { get; set; }
        public string UserName { get; set; }
        public string ProfileImage { get; set; }
    }
}
