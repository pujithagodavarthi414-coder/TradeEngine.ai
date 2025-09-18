using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.ActTracker
{
    public class ActivityTrackerDesktopsModel : SearchCriteriaInputModelBase
    {
        public ActivityTrackerDesktopsModel() : base(InputTypeGuidConstants.GetTrackerDesktopInputCommandTypeGuid)
        {
        }

        public Guid? DesktopId { get; set; }
        public string DesktopName { get; set; }
        public string DesktopDeviceId { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public string CreatedByUser { get; set; }
        public DateTime CreatedDateTime { get; set; }
        public int TotalCount { get; set; }
        public string CompanyUrl { get; set; }
        public Guid? UserId { get; set; }
    }
}
