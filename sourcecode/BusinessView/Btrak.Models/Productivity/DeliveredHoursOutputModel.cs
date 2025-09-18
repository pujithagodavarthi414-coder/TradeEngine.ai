using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.Productivity
{
   public  class DeliveredHoursOutputModel
    {
        public DateTime Date { get; set; }
        public Decimal DeliveredHours { get; set; }
        public int CompletedTasks { get; set; }
        public string Names { get; set; }
    }
}
