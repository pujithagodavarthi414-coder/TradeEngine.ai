using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.Integration
{
    public class WorkLogTimeInputModel
    {
        public string WorkItemId { get; set; }
        public string WorkItemKey { get; set; }
        public string WorkItemType { get; set; }
        public string AssigneeId { get; set; }
        public string SpentTime { get; set; }
        public Int64 SpentTimeSeconds { get; set; }
    }
}
