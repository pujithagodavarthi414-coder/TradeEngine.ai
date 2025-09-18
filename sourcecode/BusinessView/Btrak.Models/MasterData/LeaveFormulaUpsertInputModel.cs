using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.MasterData
{
    public class LeaveFormulaUpsertInputModel:InputModelBase
    {
        public LeaveFormulaUpsertInputModel() : base(InputTypeGuidConstants.LeaveFormulaUpsertInputModel)
        {
        }
        public Guid? LeaveFormulaId { get; set; }
        public int NoOfDays { get; set; }
        public int NoOfLeaves { get; set; }
        public bool? IsArchived { get; set; }
        public string Formula { get; set; }
        public Guid? SalaryTypeId { get; set; }
        public Guid? PayroleId { get; set; }
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("LeaveFormulaId" + LeaveFormulaId);
            stringBuilder.Append(", NoOfDays" + NoOfDays);
            stringBuilder.Append(", NoOfLeaves" + NoOfLeaves);
            stringBuilder.Append(", NoOfLeaves" + NoOfLeaves);
            stringBuilder.Append(", Formula" + Formula);
            stringBuilder.Append(", IsArchived" + IsArchived);
            stringBuilder.Append(", PayroleId" + PayroleId);
            return stringBuilder.ToString();
        }
    }
}
