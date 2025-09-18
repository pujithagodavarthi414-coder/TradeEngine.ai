using System;
using System.Text;

namespace Btrak.Models.MasterData
{
    public class RateSheetForOutputModel
    {
        public Guid RateSheetForId { get; set; }
        public string RateSheetForName { get; set; }
        public Guid? CompanyId { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public byte[] TimeStamp { get; set; }
        public bool? IsArchived { get; set; }
        public bool? IsShift { get; set; }
        public bool? IsAllowance { get; set; }
        public int? TotalCount { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", RateSheetForId = " + RateSheetForId);
            stringBuilder.Append(", RateSheetForName = " + RateSheetForName);
            stringBuilder.Append(", CompanyId = " + CompanyId);
            stringBuilder.Append(", CreatedDateTime = " + CreatedDateTime);
            stringBuilder.Append(", CreatedByUserId = " + CreatedByUserId);
            stringBuilder.Append(", IsShift = " + IsShift);
            stringBuilder.Append(", IsAllowance = " + IsAllowance);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", TotalCount = " + TotalCount);
            return stringBuilder.ToString();
        }
    }
}
