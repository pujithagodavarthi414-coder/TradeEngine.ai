using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.Productivity
{
    public class NoOfBounceBacksOutputModel
    {
        public string TaskId { get; set; }
        public string TaskName { get; set; }
        public float EstimatedTime { get; set; }
        public float SpentTimeInMin { get; set; }
        public float OthersSpentTimeInMin { get; set; }
        public string ApprovedBy { get; set; }
        public DateTime? DeadLineDate { get; set; }
        public DateTime? DoneDate { get; set; }
        public string CurrentStatus { get; set; }
        public int NoOfBounceBacks { get; set; }
        public int NoOfReplans { get; set; }
        public string UserName { get; set; }
    }
}
