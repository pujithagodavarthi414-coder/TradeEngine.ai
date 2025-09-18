using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.Goals
{
    public class ArchiveGoalFilterModel
    {
        public Guid? GoalFilterId { get; set; }
        public bool? IsArchived { get; set; }
    }
}
