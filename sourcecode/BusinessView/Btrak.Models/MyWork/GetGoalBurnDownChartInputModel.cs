using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.MyWork
{
    public class GetGoalBurnDownChartInputModel
    {
        public Guid? UserId { get; set; }
        public DateTime? DateTo { get; set; }
        public DateTime? DateFrom { get; set; }
        public Guid? GoalId { get; set; }
        public Guid? SprintId { get; set; }
        public bool? IsFromSprint { get; set; }
        public bool? UserStoryPoints { get; set; }
        public bool? IsApplyFilters { get; set; }
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(" UserId = " + UserId);
            stringBuilder.Append(", DateTo = " + DateTo);
            stringBuilder.Append(" GoalId = " + GoalId);
            stringBuilder.Append(", DateFrom = " + DateFrom);
            return stringBuilder.ToString();
        }
    }
   
}
