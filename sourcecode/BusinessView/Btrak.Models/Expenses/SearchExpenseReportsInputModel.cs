using System;
using System.Collections.Generic;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.Expenses
{
    public class SearchExpenseReportsInputModel :  SearchCriteriaInputModelBase
    {
        public SearchExpenseReportsInputModel() : base(InputTypeGuidConstants.SearchExpenseReportsInputCommandTypeGuid)
        {
        }
        public Guid? ExpenseReportId { get; set; }
        public DateTime? DurationFrom { get; set; }
        public DateTime? DurationTo { get; set; }
        public Guid? ReportStatusId { get; set; }
        public bool? IsReimbursed { get; set; }
        public bool? IsApproved { get; set; }
        
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("ExpenseReportId = " + ExpenseReportId);
            stringBuilder.Append(", DurationFrom = " + DurationFrom);
            stringBuilder.Append(",DurationTo = " + DurationTo);
            stringBuilder.Append(", ReportStatusId = " + ReportStatusId);
            stringBuilder.Append(",IsReimbursed = " + IsReimbursed);
            stringBuilder.Append(", IsApproved = " + IsApproved);
            return stringBuilder.ToString();
        }

    }
}
