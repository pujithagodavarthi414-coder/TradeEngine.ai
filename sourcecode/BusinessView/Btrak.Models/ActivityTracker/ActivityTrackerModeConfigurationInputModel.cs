using System;
using System.Collections.Generic;

namespace Btrak.Models.ActivityTracker
{
    public class ActivityTrackerModeConfigurationInputModel
    {
        public Guid Id { get; set; }
        public Guid CompanyId { get; set; }
        public Guid ModeId { get; set; }
        public List<string> RolesIds { get; set; }
        public bool ShiftBased { get; set; }
        public bool PunchCardBased { get; set; }
    }
}
