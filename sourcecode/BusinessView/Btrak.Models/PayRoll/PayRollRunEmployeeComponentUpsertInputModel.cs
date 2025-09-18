using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.PayRoll
{
    public class PayRollRunEmployeeComponentUpsertInputModel : InputModelBase
    {
        public PayRollRunEmployeeComponentUpsertInputModel() : base(InputTypeGuidConstants.PayRollRunEmployeeComponentInputCommandTypeGuid)
        {
        }

        public Guid? PayRollRunEmployeeComponentId { get; set; }
        public Guid? PayRollRunId { get; set; }
        public Guid? EmployeeId { get; set; }
        public Guid? ComponentId { get; set; }
        public decimal ActualComponentAmount { get; set; }
        public decimal? ComponentAmount { get; set; }
        public string Comments { get; set; }
        public string YTDComments { get; set; }
        public bool? IsDeduction { get; set; }
        public Guid? PayRollRunEmployeeComponentYtdId { get; set; }
        public decimal? OriginalComponentAmount { get; set; }
        public bool AddOrUpdateComponent { get; set; }
        public bool AddOrUpdateYtdComponent { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("PayRollRunEmployeeComponentId = " + PayRollRunEmployeeComponentId);
            stringBuilder.Append(",PayRollRunId = " + EmployeeId);
            stringBuilder.Append(",ComponentId = " + ComponentId);
            stringBuilder.Append(",ActualComponentAmount = " + ActualComponentAmount);
            stringBuilder.Append(",ComponentAmount = " + ComponentAmount);
            stringBuilder.Append(",OriginalComponentAmount = " + OriginalComponentAmount);
            stringBuilder.Append(",Comments = " + Comments);
            stringBuilder.Append(",YTDComments = " + YTDComments);
            stringBuilder.Append(",IsDeduction = " + IsDeduction);
            stringBuilder.Append(",AddOrUpdateComponent = " + AddOrUpdateComponent);
            stringBuilder.Append(",AddOrUpdateYtdComponent = " + AddOrUpdateYtdComponent);
            stringBuilder.Append("PayRollRunEmployeeComponentYtdId = " + PayRollRunEmployeeComponentYtdId);
            return stringBuilder.ToString();
        }
    }
}
