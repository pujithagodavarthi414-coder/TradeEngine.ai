using System;
using System.Text;

namespace Btrak.Models.CompanyStructure
{
    public class IntroducedByOptionsOutputModel
    {
        public Guid? CompanyIntroducedByOptionId { get; set; }
        public string Option { get; set; }
        public Guid? CompanyId { get; set; }
        public byte[] TimeStamp { get; set; }
        public DateTime? InActiveDateTime { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public int? TotalCount { get; set; }
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", CompanyIntroducedByOptionId = " + CompanyIntroducedByOptionId);
            stringBuilder.Append(", Option  = " + Option);
            stringBuilder.Append(", CompanyId  = " + CompanyId);
            stringBuilder.Append(", TimeStamp   = " + TimeStamp);
            stringBuilder.Append(", InActiveDateTime  = " + InActiveDateTime);
            stringBuilder.Append(", CreatedDateTime   = " + CreatedDateTime);
            stringBuilder.Append(", CreatedByUserId  = " + CreatedByUserId);
            stringBuilder.Append(", TotalCount  = " + TotalCount);
            return stringBuilder.ToString();
        }
    }
}
