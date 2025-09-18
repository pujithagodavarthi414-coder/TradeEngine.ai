using System;
using System.Collections.Generic;
using System.Linq;

namespace Btrak.Models.ActivityTracker
{
    public class ActivityTrackerModeConfigurationOutputModel
    {
        public Guid Id { get; set; }
        public Guid CompanyId { get; set; }
        public Guid ModeId { get; set; }
        public string RolesIdsString { get; set; }
        public List<string> RolesIds 
        {
            get
            {
                if (!string.IsNullOrEmpty(RolesIdsString))
                {
                    return RolesIdsString.Split(',').ToList();
                }
                return new List<string>();
            }
        }
        public bool ShiftBased { get; set; }
        public bool PunchCardBased { get; set; }
    }
}
