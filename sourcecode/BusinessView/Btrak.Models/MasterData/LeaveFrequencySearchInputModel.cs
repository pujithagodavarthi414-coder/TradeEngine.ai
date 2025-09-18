using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.MasterData
{
    public class LeaveFrequencySearchInputModel : SearchCriteriaInputModelBase
    {
        public LeaveFrequencySearchInputModel() : base(InputTypeGuidConstants.LeaveFrequencySearchInputModel)
        {
        }

        public Guid? LeaveFrequencyId { get; set; }
        public Guid? LeaveTypeId { get; set; }
        public DateTime? FromDate { get; set; }
        public DateTime? ToDate { get; set; }
        public decimal NoOfLeaves { get; set; }
        public bool? IsToGetLeaveTypes { get; set; }
        public DateTime? Date { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("  LeaveFrequencyId" + LeaveFrequencyId);
            stringBuilder.Append("  LeaveTypeId" + LeaveTypeId);
            stringBuilder.Append(", FromDate" + FromDate);
            stringBuilder.Append(", ToDate" + ToDate);
            stringBuilder.Append(", NoOfLeaves" + NoOfLeaves);
            stringBuilder.Append(", IsArchived" + IsArchived);
            stringBuilder.Append(", IsToGetLeaveTypes" + IsToGetLeaveTypes);
            stringBuilder.Append(", Date" + Date);
            return stringBuilder.ToString();
        }
    }
}
