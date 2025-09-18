using System;
using static BTrak.Common.Enumerators;

namespace Btrak.Models.ActTracker
{
    public class TrackerModeOutputModel
    {
        public string DeviceId { get; set; }
        public ModeType ModeTypeEnum { get; set; }
        public Guid? UserId { get; set; }
        public Guid? CompanyId { get; set; }
    }
}
