using System;
using BTrak.Common;

namespace Btrak.Models.MasterData
{
    public class RestrictionTypeSearchOutputModel
    { 
        public Guid? RestrictionTypeId { get; set; }
        public string RestrictionType { get; set; }
        public float? LeavesCount { get; set; }
        public string Type { get; set; }
        public bool? IsWeekly { get; set; }
        public bool? IsMonthly { get; set; }
        public bool? IsQuarterly { get; set; }
        public bool? IsHalfYearly { get; set; }
        public bool? IsYearly { get; set; }
        public bool? IsArchive { get; set; }
        public byte[] TimeStamp { get; set; }
        public int? TotalCount { get; set; }

    }
}