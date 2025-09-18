using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.MasterData
{
    public class LeaveFormulaSearchInputModel : InputModelBase
    {
        public LeaveFormulaSearchInputModel() : base(InputTypeGuidConstants.LeaveFormulaSearchInputModel)
        {
        }

        public Guid? LeaveFormulaId { get; set; }
        public decimal? NoOfDays { get; set; }
        public string Formula { get; set; }
        public decimal NoOfLeaves { get; set; }
        public bool? IsArchived { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("   LeaveFormulaId" + LeaveFormulaId);
            stringBuilder.Append(", NoOfDays" + NoOfDays);
            stringBuilder.Append(", Formula" + Formula);
            stringBuilder.Append(", NoOfLeaves" + NoOfLeaves);
            stringBuilder.Append(", IsArchived" + IsArchived);
            return stringBuilder.ToString();
        }
    }
}
