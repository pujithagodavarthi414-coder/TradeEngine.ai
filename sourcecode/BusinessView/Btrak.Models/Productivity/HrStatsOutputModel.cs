using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.Productivity
{
    public class HrStatsOutputModel
    {
        public float NoOfAbsences { get; set; }
        public float NoOfUnplannedAbsences { get; set; }
        public int Latemornings { get; set; }
        public int Earlyfinishes { get; set; }
        public int Latelunches { get; set; }
        public int LongBreaks { get; set; }
        public float UnProductivPercentage { get; set; }
        public float IdelPercentage { get; set; }
    }
}
