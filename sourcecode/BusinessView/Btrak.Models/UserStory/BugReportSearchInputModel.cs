using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.UserStory
{
   public  class BugReportSearchInputModel
    {
        public Guid? SprintId { get; set; }
        public Guid? UserStoryId { get; set; }
        public Guid? OwnerUserId { get; set; }
    }
}
