using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.ActivityTracker
{
    public class TrackerInsertValidatorInputModel
    {
        public Guid? UserId { get; set; }
        public string DeviceId { get; set; }
        public DateTimeOffset? TriggeredDate { get; set; }
        public string MacAddress { get; set; }
        public string TimeZone { get; set; }
    }
}
