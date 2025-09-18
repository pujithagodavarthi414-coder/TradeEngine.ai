using System;
using System.Collections.Generic;
using System.Text;

namespace Btrak.Models.Expenses
{
    public class ExpenseReportSummaryOutputModel
    {
        public int? UnSubmittedReportsCount { get; set; }
        public int? UnsubmittedReportExpensesAmount { get; set; }
        public int? ReiumbersedExpensesCount { get; set; }
        public int? ReiumbersedExpensesAmount { get; set; }
        public int? AwaitingReiumbersementExpensesCount { get; set; }
        public int? AwaitingReiumbersementExpensesAmount { get; set; }
        public int? UnReportedExpensesCount { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("UnSubmittedReportsCount = " + UnSubmittedReportsCount);
            stringBuilder.Append(", UnsubmittedReportExpensesAmount = " + UnsubmittedReportExpensesAmount);
            stringBuilder.Append(", ReiumbersedExpensesCount = " + ReiumbersedExpensesCount);
            stringBuilder.Append(", ReiumbersedExpensesAmount = " + ReiumbersedExpensesAmount);
            stringBuilder.Append("AwaitingReiumbersementExpensesCount = " + AwaitingReiumbersementExpensesCount);
            stringBuilder.Append(", AwaitingReiumbersementExpensesAmount = " + AwaitingReiumbersementExpensesAmount);
            stringBuilder.Append(", UnReportedExpensesCount = " + UnReportedExpensesCount);
            return stringBuilder.ToString();
        }
    }
}
