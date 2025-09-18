using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.Performance
{
    public class InductionModel
    {
        public Guid? InductionId { get; set; }
        public string InductionName { get; set; }
        public bool IsShow { get; set; }
        public bool IsArchived { get; set; }
    }
}
