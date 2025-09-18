using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.PayRoll
{
    public class PayRollRunEmployeeComponentYTDUpsertInputModel : InputModelBase
    {
        public PayRollRunEmployeeComponentYTDUpsertInputModel() : base(InputTypeGuidConstants.PayRollRunEmployeeComponentYTDInputCommandTypeGuid)
        {
        }

        public Guid? PayRollRunEmployeeComponentYtdId { get; set; }
        public Guid? PayRollRunId { get; set; }
        public Guid? EmployeeId { get; set; }
        public Guid? ComponentId { get; set; }
        public decimal OriginalComponentAmount { get; set; }
        public decimal ComponentAmount { get; set; }
        public string Comments { get; set; }
        public bool? IsDeduction { get; set; }


        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("PayRollRunEmployeeComponentYtdId = " + PayRollRunEmployeeComponentYtdId);
            stringBuilder.Append(",PayRollRunId = " + EmployeeId);
            stringBuilder.Append(",ComponentId = " + ComponentId);
            stringBuilder.Append(",OriginalComponentAmount = " + OriginalComponentAmount);
            stringBuilder.Append(",Comments = " + Comments);
            stringBuilder.Append(",IsDeduction = " + IsDeduction);
            stringBuilder.Append(",ComponentAmount = " + ComponentAmount);
            return stringBuilder.ToString();
        }
    }
}
