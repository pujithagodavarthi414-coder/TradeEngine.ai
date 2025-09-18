using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.ActTracker
{
    public class GetActTrackerScreenShotFrequencyRolesOutputModel
    {
        public Guid? ActTrackerScreenShotId { get; set; }
        public Guid? RoleId { get; set; }
        public Guid? UserId { get; set; }
        public string RoleName { get; set; }
        public int? ScreenShotFrequency { get; set; }
        public int? Multiplier { get; set; }
        public int? FrequencyIndex { get; set; }
        public bool? SelectAll { get; set; }
        public bool? IsUserSelectAll { get; set; }
        public bool? RandomScreenshot { get; set; }
    }

    public class ActTrackerScreenShotFrequencyRoles
    {
        public List<Guid?> ActTrackerScreenShotId { get; set; }
        public List<Guid?> RoleId { get; set; }
        public List<Guid?> UserId { get; set; }
        public List<string> RoleName { get; set; }
        public int? ScreenShotFrequency { get; set; }
        public int? Multiplier { get; set; }
        public int? FrequencyIndex { get; set; }
        public bool? SelectAll { get; set; }
        public bool? IsUserSelectAll { get; set; }
    }

    public class ActTrackerScreenShotFrequency
    {
        public int? ScreenShotFrequency { get; set; }
        public int? Multiplier { get; set; }
        public bool? RandomScreenshot { get; set; }
        public List<ActTrackerScreenShotFrequencyRoles> IndividualRoles {get;set;}
    }
}