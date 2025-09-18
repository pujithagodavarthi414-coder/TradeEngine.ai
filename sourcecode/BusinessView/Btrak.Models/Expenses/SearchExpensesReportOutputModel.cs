using System;
using System.Text;

namespace Btrak.Models.Expenses
{
    public class SearchExpensesReportOutputModel
    {
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
        public string ReasonForApprovalOrRejection { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public Guid? SubmittedByUserId { get; set; }
        public DateTime? SubmittedDateTime { get; set; }
        public Guid? ReimbursedByUserId { get; set; }
        public DateTime? ReimbursedDateTime { get; set; }
        public Guid? ApprovedOrRejectedByUserId { get; set; }
        public DateTime? ApprovedOrRejectedDateTime { get; set; }
        public string StatusName { get; set; }
        public int? TotalCount { get; set; }
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("ExpenseReportId = " + ExpenseReportId);
            stringBuilder.Append(", ReportTitle = " + ReportTitle);
            stringBuilder.Append(", BusinessPurpose = " + BusinessPurpose);
            stringBuilder.Append(", DurationFrom = " + DurationFrom);
            stringBuilder.Append("DurationTo = " + DurationTo);
            stringBuilder.Append(", ReportStatusId = " + ReportStatusId);
            stringBuilder.Append(", AdvancePayment = " + AdvancePayment);
            stringBuilder.Append(", AmountToBeReimbursed = " + AmountToBeReimbursed);
            stringBuilder.Append("IsReimbursed = " + IsReimbursed);
            stringBuilder.Append(", UndoReimbursement = " + UndoReimbursement);
            stringBuilder.Append(", IsApproved = " + IsApproved);
            stringBuilder.Append(", ReasonForApprovalOrRejection = " + ReasonForApprovalOrRejection);
            stringBuilder.Append(", CreatedByUserId = " + CreatedByUserId);
            stringBuilder.Append(", CreatedDateTime = " + CreatedDateTime);
            stringBuilder.Append(", SubmittedByUserId = " + SubmittedByUserId);
            stringBuilder.Append(", SubmittedDateTime = " + SubmittedDateTime);
            stringBuilder.Append("ReimbursedByUserId = " + ReimbursedByUserId);
            stringBuilder.Append(", ReimbursedDateTime = " + ReimbursedDateTime);
            stringBuilder.Append(", ApprovedOrRejectedByUserId = " + ApprovedOrRejectedByUserId);
            stringBuilder.Append(", ApprovedOrRejectedDateTime = " + ApprovedOrRejectedDateTime);
            stringBuilder.Append(", StatusName = " + StatusName);
            stringBuilder.Append(", TotalCount = " + TotalCount);
            return stringBuilder.ToString();
        }
    }
}
