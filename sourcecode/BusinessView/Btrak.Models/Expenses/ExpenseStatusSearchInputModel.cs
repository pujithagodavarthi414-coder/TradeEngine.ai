using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.Expenses
{
    public class ExpenseStatusSearchInputModel : SearchCriteriaInputModelBase
    {
        public ExpenseStatusSearchInputModel() : base(InputTypeGuidConstants.SearchExpenseStatusInputCommandTypeGuid)
        {
        }

        public Guid? ExpenseStatusId { get; set; }
        public string Name { get; set; }
        public string Description { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("@ExpenseStatusId = " + ExpenseStatusId);
            stringBuilder.Append(", @Name = " + Name);
            stringBuilder.Append(", @Description = " + Description);
            return stringBuilder.ToString();
        }
    }
}
