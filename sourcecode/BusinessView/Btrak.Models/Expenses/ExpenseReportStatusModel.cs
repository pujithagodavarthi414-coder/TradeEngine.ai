using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.Expenses
{
    public class ExpenseReportStatusModel
    {
        public Guid? ExpenseReportStatusId { get; set; }
        public string Name { get; set; }
        public string Description { get; set; }
        public int TotalCount { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("ExpenseReportStatusId" + ExpenseReportStatusId);
            stringBuilder.Append(", Name" + Name);
            stringBuilder.Append(", Description" + Description);
            stringBuilder.Append(", TotalCount" + TotalCount);
            return stringBuilder.ToString();
        }
    }
}
