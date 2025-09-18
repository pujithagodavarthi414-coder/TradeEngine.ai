using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.Productivity
{
    public class ProductivityStatsOutputModel
    {
        public float CapacityHours { get; set; }
        public float PlannedHours { get; set; }
        public float DeliveredHours { get; set; }
        public int SpentHoursInMIn { get; set; }
        public int CompletedTasks { get; set; }
        public int PendingTasks { get; set; }
        public int NoOfBugs { get; set; }
        public int NoOfbouncebacks { get; set; }
        public int ReplanedTasks { get; set; }
        public int OthersTimeInMIn { get; set; }
        public int P0Bugs { get; set; }
        public int P1Bugs { get; set; }
        public int P2Bugs { get; set; }
        public int P3Bugs { get; set; }
    }
}
