using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.ActivityTracker
{
    public class TeamActivityOutputModel
    {
        public string UserName { get; set; }
        public float Productive { get; set; }
        public float UnProductive { get; set; }
        public float Neutral { get; set; }
        public int ProductiveInSec { get; set; }
        public int UnProductiveInSec { get; set; }
        public int NeutralInSec { get; set; }
        public float TotalTime { get; set; }
        public float IdleTime { get; set; }
    }
}
