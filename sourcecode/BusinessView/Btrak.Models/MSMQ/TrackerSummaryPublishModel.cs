using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.MSMQ
{
    public class TrackerSummaryPublishModel
    {
        public Guid? UserId { get; set; }
        public string TrackedDate { get; set; }
        public int RetryCount { get; set; }
    }
}
