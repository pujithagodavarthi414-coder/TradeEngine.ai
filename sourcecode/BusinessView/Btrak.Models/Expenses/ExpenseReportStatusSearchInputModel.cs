using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using BTrak.Common;

namespace Btrak.Models.Expenses
{
    public class ExpenseReportStatusSearchInputModel : SearchCriteriaInputModelBase
    {
        public ExpenseReportStatusSearchInputModel() : base(InputTypeGuidConstants.ExpenseReportStatusSearchInputCommandTypeGuid)
        {
        }

        public Guid? ExpenseReportStatusId { get; set; }
        public string Name { get; set; }
        public string Description { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("ExpenseReportStatusId = " + ExpenseReportStatusId);
            stringBuilder.Append(", Name = " + Name);
            stringBuilder.Append(", Description = " + Description);
            return stringBuilder.ToString();
        }
    }
}
