using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.PayRoll
{
    public class UpsertAllowanceTimeInputModel : InputModelBase
    {
        public UpsertAllowanceTimeInputModel() : base(InputTypeGuidConstants.UpsertAllowanceTimeInputCommandTypeGuid)
        {
        }

        public Guid? Id { get; set; }
        public Guid BranchId { get; set; }
        public Guid AllowanceRateSheetForId { get; set; }
        public decimal? MaxTime { get; set; }
        public decimal? MinTime { get; set; }
        public DateTime ActiveFrom { get; set; }
        public DateTime? ActiveTo { get; set; }
        public bool? IsArchived { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("Id = " + Id);
            stringBuilder.Append(",BranchId = " + BranchId);
            stringBuilder.Append(",AllowanceRateSheetForId = " + AllowanceRateSheetForId);
            stringBuilder.Append(",MaxTime = " + MaxTime);
            stringBuilder.Append(",MinTime = " + MinTime);
            stringBuilder.Append(",ActiveFrom = " + ActiveFrom);    
            stringBuilder.Append(",ActiveTo = " + ActiveTo);
            stringBuilder.Append(",IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}
