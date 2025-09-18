using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.Projects
{
    public class CumulativeWorkReportModel
    {
        public DateTime? Date { get; set; }
        public int ToDoStatusWorkitemsCount { get; set; }
        public int InprogressStatusWorkitemsCount { get; set; }
        public int DoneStatusWorkitemsCount { get; set; }
        public int PendingVerificationStatusWorkitemsCount { get; set; }
        public int VerificationCompletedStatusWorkitemsCount { get; set; }
        public int BlockedStatusWorkitemsCount { get; set; }
    }
}
