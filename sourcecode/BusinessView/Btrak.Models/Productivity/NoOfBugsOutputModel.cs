using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.Productivity
{
    public class NoOfBugsOutputModel
    {
        public string TaskId { get; set; }
        public string TaskName { get; set; }
        public string Priority { get; set; }
        public string SpentHours { get; set; }
        public string OthersSpentHours { get; set; }
        public string Name { get; set; }
        public string BugCausedByUser { get; set; }
    }
}
