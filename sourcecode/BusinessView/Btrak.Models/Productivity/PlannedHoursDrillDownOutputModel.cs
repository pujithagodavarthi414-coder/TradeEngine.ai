using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.Productivity
{
    public class PlannedHoursDrillDownOutputModel
    {
        public DateTime Date { get; set; }
        public Decimal PlannedHours { get; set; }
        public int TasksAssigned { get; set; }
        public string Names { get; set; }
    }
}
