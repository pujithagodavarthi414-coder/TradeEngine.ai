using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.MasterData
{
    public class RestrictionTypeUpsertInputModel : InputModelBase
    {
        public RestrictionTypeUpsertInputModel() : base(InputTypeGuidConstants.RestrictionTypeUpsertInputOutputModelGuid)
        {
        }

        public Guid? RestrictionTypeId { get; set; }
        public string RestrictionType { get; set; }
        public float LeavesCount { get; set; }
        public bool? IsWeekly { get; set; }
        public bool? IsMonthly { get; set; }
        public bool? IsQuarterly { get; set; }
        public bool? IsHalfYearly { get; set; }
        public bool? IsYearly { get; set; }
        public bool? IsArchived { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("RestrictionTypeId = " + RestrictionTypeId);
            stringBuilder.Append(", RestrictionType = " + RestrictionType);
            stringBuilder.Append(", LeavesCount = " + LeavesCount);
            stringBuilder.Append(", IsWeekly = " + IsWeekly);
            stringBuilder.Append(", IsMonthly = " + IsMonthly);
            stringBuilder.Append(", IsQuarterly = " + IsQuarterly);
            stringBuilder.Append(", IsYearly = " + IsYearly);
            stringBuilder.Append(", IsHalfYearly = " + IsHalfYearly);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}
