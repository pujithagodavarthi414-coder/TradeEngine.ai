using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.ActivityTracker
{
    public class AvailabilityCalendarInputModel: InputModelBase
    {
        public AvailabilityCalendarInputModel() : base(InputTypeGuidConstants.AvailabilityCalendarInputTypeGuid)
        {
        }

        public Guid? UserId { get; set; }
        public DateTime? DateFrom { get; set; }
        public DateTime? DateTo { get; set; }
    }
}
