using System;
using System.Collections.Generic;

namespace Btrak.Models.PayRoll
{
    public class PayrollRunOutPutModel
    {
        public PayrollRunOutPutModel(){

            PayrollRunOutPutModelList = new List<PayrollRunOutPutModel>();
        }

        public Guid? EmployeeId { get; set; }
        public string EmployeeName { get; set; }
        public string EmployeeNumber { get; set; }
        public string NetPay { get; set; }
        public decimal TotalWorkingDays { get; set; }
        public decimal EffectiveWorkingDays { get; set; }
        public decimal LossOfPay { get; set; }
        public decimal EncashedLeaves { get; set; }
        public bool? IsManualLeaveManagement { get; set; }
        public decimal OriginalLossOfPay { get; set; }
        public decimal OriginalEncashedLeaves { get; set; }
        public decimal ActualPaidAmount { get; set; }
        public bool? ImportStatus { get; set; }
        public string ProfileImage { get; set; }
        public Guid? UserId { get; set; }

        public List<PayrollRunOutPutModel> PayrollRunOutPutModelList { get; set; }
    }
}
