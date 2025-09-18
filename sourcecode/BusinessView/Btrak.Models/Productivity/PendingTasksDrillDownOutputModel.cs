using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.Productivity
{
    public class PendingTasksDrillDownOutputModel
    {
        public string TaskId { get; set; }
        public string TaskName { get; set; }
        public Decimal EstimatedTime { get; set; }
        public string SpentTime { get; set; }
        public DateTimeOffset? DeadlineDate { get; set; }
        public string CurrentStatus { get; set; }
        public string OthersTime { get; set; }
        public string Names { get; set; }
    }
}
