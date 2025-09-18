using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.ActivityTracker
{
    public class TimeUsageSearchOutputModel
    {
        public TimeUsageSearchOutputModel()
        {

        }
        public DateTime OperationDate { get; set; }
        public double Productive { get; set; }
        public double UnProductive { get; set; }
        public double Neutral { get; set; }
        public double Idle { get; set; }
        public double TotalTime { get; set; }
        public double ProductiveTime { get; set; }
        public double UnProductiveTime { get; set; }
        public double NeutralTime { get; set; }
        public double IdleTime { get; set; }
        public int TotalCount { get; set; }
    }
}
