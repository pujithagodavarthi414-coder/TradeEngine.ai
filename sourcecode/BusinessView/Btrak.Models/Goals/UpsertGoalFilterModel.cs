using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.Goals
{
    public class UpsertGoalFilterModel
    {
        public Guid? GoalFilterId { get; set; }
        public string GoalFilterName { get; set; }
        public bool? IsPublic { get; set; }
        public Guid? GoalFilterDetailsId { get; set; }
        public GoalFilterJsonModel GoalFilterDetailsJsonModel { get; set; }
        public string GoalFilterDetailsJson { get; set; }


    }
}
