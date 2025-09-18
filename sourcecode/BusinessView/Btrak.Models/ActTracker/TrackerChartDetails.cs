using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.ActTracker
{
    public class TrackerChartDetails
    {
        public int KeyStroke { get; set; }
        public int MouseMovement { get; set; }
        public int TenthMinute { get; set; }
        public int TrackedHour { get; set; }
        public int TrackedTenthMinute { get; set; }
        public string TimeZoneAbbreviation { get; set; }
        public Guid TimeZoneId { get; set; }
        public string StartTime { get; set; }
        public string EndTime { get; set; }
    }
}
