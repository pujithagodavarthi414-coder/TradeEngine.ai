using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models
{
  public  class UserstoryReferences
    {
        public Guid? GoalId { get; set; }
        public Guid? TypeId { get; set; }
        public Guid? UserStatusId { get; set; }
    }
}
