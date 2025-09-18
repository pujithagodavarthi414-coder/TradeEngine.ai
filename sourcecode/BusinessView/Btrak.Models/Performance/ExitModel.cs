using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.Performance
{
    public class ExitModel
    {
        public Guid? ExitId { get; set; }
        public string ExitName { get; set; }
        public bool IsShow { get; set; }
        public bool IsArchived { get; set; }
        public Guid? UserId { get; set; }
    }
}
