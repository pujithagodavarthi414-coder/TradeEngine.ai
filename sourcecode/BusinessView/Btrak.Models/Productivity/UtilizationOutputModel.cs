using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.Productivity
{
   public class UtilizationOutputModel
    {
        public DateTime? Date { get; set; }
        public float UtilizationPercentage { get; set; }
        public string Name { get; set; }
    }
}
