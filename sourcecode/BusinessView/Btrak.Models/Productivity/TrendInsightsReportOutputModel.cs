using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.Productivity
{
    public class TrendInsightsReportOutputModel
    {
        public DateTime? Date { get; set; }
        public float Productivity { get; set; }
        public float Efficiency { get; set; }
        public float Utilization { get; set; }
        public float Predictabulity { get; set; }
        public int NoOfBugscausedByUserSelf { get; set; }
        public int TeamRank { get; set; }
        public int OfficeRank { get; set; }

    }
}
