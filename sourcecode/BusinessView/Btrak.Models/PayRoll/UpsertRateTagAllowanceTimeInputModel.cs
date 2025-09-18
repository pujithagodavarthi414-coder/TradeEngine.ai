using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Text;

namespace Btrak.Models.PayRoll
{
    public class UpsertRateTagAllowanceTimeInputModel : InputModelBase
    {
        public UpsertRateTagAllowanceTimeInputModel() : base(InputTypeGuidConstants.UpsertRateTagAllowanceTimeInputCommandTypeGuid)
        {
        }

        public Guid? Id { get; set; }
        public Guid BranchId { get; set; }
        public Guid? AllowanceRateTagForId { get; set; }
        public decimal? MaxTime { get; set; }
        public decimal? MinTime { get; set; }
        public DateTime ActiveFrom { get; set; }
        public DateTime? ActiveTo { get; set; }
        public bool? IsArchived { get; set; }
        public bool IsBankHoliday { get; set; }
        public List<RateTagForTypeModel> AllowanceRateTagForIds { get; set; }
        public string AllowanceRateTagForIdsXml { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("Id = " + Id);
            stringBuilder.Append(",BranchId = " + BranchId);
            stringBuilder.Append(",AllowanceRateTagForId = " + AllowanceRateTagForId);
            stringBuilder.Append(",MaxTime = " + MaxTime);
            stringBuilder.Append(",MinTime = " + MinTime);
            stringBuilder.Append(",ActiveFrom = " + ActiveFrom);    
            stringBuilder.Append(",ActiveTo = " + ActiveTo);
            stringBuilder.Append(",IsArchived = " + IsArchived);
            stringBuilder.Append(",IsBankHoliday = " + IsBankHoliday);
            return stringBuilder.ToString();
        }
    }
}
