using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Text;

namespace Btrak.Models.Expenses
{
    public class ExpenseReportInputModel : InputModelBase
    {
        public ExpenseReportInputModel() : base(InputTypeGuidConstants.UpsertExpensesReportInputTypeCommandGuid)
        {
        }
        public Guid? ExpenseReportId { get; set; }
        public string ReportTitle { get; set; }
        public string BusinessPurpose { get; set; }
        public DateTime? DurationFrom { get; set; }
        public DateTime? DurationTo { get; set; }
        public Guid? ReportStatusId { get; set; }
        public decimal? AdvancePayment { get; set; }
        public decimal? AmountToBeReimbursed { get; set; }
        public bool? IsReimbursed { get; set; }
        public bool? UndoReimbursement { get; set; }
        public bool? IsApproved { get; set; }
        public bool? IsArchived { get; set; }
        public string ReasonForApprovalOrRejection { get; set; }
        public List<Guid?> ExpensesList { get; set; }
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("ExpenseReportId = " + ExpenseReportId);
            stringBuilder.Append(", ReportTitle = " + ReportTitle);
            stringBuilder.Append(", BusinessPurpose = " + BusinessPurpose);
            stringBuilder.Append(", DurationFrom = " + DurationFrom);
            stringBuilder.Append(",DurationTo = " + DurationTo);
            stringBuilder.Append(", ReportStatusId = " + ReportStatusId);
            stringBuilder.Append(", AdvancePayment = " + AdvancePayment);
            stringBuilder.Append(", AmountToBeReimbursed = " + AmountToBeReimbursed);
            stringBuilder.Append(",IsReimbursed = " + IsReimbursed);
            stringBuilder.Append(", UndoReimbursement = " + UndoReimbursement);
            stringBuilder.Append(", IsApproved = " + IsApproved);
            stringBuilder.Append(", ReasonForApprovalOrRejection = " + ReasonForApprovalOrRejection);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            return stringBuilder.ToString();
        }
    }
}
