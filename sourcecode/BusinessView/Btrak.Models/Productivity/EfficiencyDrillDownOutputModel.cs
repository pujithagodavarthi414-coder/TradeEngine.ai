using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.Productivity
{
    public class EfficiencyDrillDownOutputModel
    {
        public DateTime? Date { get; set; }
        public int ProductiveTime { get; set; }
        public int Workdeliveredhours { get; set; }
        public string Name { get; set; }
    }
}
