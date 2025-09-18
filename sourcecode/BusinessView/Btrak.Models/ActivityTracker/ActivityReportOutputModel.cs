using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.ActivityTracker
{
    public class ActivityReportOutputModel
    {
        public string AppUrlName { get; set; }
        public string CategoryName { get; set; }
        public string AppUrlImage { get; set; }
        public string ApplicationTypeName { get; set; }
        public string TotalTime { get; set; }
        public float Neutral { get; set; }
        public float Productive { get; set; }
        public float UnProductive { get; set; }
        public string ProductiveRoles { get; set; }
        public string UnProductiveRoles { get; set; }
        public float TotalTimeInHr { get; set; }
    }
}
