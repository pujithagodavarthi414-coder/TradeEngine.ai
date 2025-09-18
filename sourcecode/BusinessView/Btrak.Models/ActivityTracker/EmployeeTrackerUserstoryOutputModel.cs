using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.ActivityTracker
{
    public class EmployeeTrackerUserstoryOutputModel
    {
        public Guid UserId { get; set; }
        public string UserName { get; set; }
        public string UserStoryName { get; set; }
        public string ApplicationTypeName { get; set; }
        public DateTime CreatedDate { get; set; }
        public DateTime StartTime { get; set; }
        public DateTime EndTime { get; set; }
        public int SpentTime { get; set; }
        public int ResourceId { get; set; }
    }
}
