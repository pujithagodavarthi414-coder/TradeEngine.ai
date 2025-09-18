using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.Productivity
{
    public class CompletedTasksDrillDownOutputModel
    {
        public string TaskId { get; set; }
        public string TaskName { get; set; }
        public float EstimatedTime { get; set; }
        public string SpentTime { get; set; }
        public string OthersTime { get; set; }
        public string ApprovedBy { get; set; }
        public DateTimeOffset? DeadlineDate { get; set; }
        public DateTimeOffset? DoneDate { get; set; }
        public string Names { get; set; }
        public DateTimeOffset? ParkedDateTime { get; set; }
    }
}
