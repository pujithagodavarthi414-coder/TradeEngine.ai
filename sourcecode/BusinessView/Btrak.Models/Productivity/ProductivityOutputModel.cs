using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.Productivity
{
    public class ProductivityOutputModel
    {
        public float Productivity { get; set; }
        public float Efficiency { get; set; }
        public float Utilization { get; set; }
        public float Predictability { get; set; }
        public string Quality { get; set; }
        public int TeamRank { get; set; }
        public int TeamSize { get; set; }
        public int OfficeRank { get; set; }
        public int OfficeSize { get; set; }
        public int BranchSize { get; set; }
        public int Companysize { get; set; }
    }
}
