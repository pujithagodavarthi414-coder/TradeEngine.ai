using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.ActTracker
{
    public class ActTrackerAppUrlOutputModel
    {
        public Guid? AppUrlId { get; set; }
        public string AppUrlName { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public DateTimeOffset? CreatedDateTime { get; set; }
        public int? VersionNumber { get; set; }
    }
}
