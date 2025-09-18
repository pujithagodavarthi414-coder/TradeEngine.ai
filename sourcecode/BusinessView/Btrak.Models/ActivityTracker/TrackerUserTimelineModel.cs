using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.ActivityTracker
{
    public class TrackerUserTimelineModel
    {
        public int Id { get; set; }
        public DateTime StartedTime { get; set; }
        public DateTime CreatedDate { get; set; }
        public Guid? UserId { get; set; }
        public string FullName { get; set; }
        public string ProfileImage { get; set; }
        public string Title { get; set; }
        public string CategoryType { get; set; }
        public int DifferenceMinutes { get; set; }
        public string Reference { get; set; }
    }
}
