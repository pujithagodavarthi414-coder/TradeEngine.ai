using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.BillingManagement
{
    public class ExpenseCategoryInputModel : SearchCriteriaInputModelBase
    {
        public ExpenseCategoryInputModel() : base(InputTypeGuidConstants.ExpenseCategoryInputCommandTypeGuid)
        {
        }

        public Guid? ExpenseCategoryId { get; set; }
        //public Guid? ExpenseId { get; set; }
        public Guid? BranchId { get; set; }
        public bool? IsArchived { get; set; }
        public string SearchText { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("ExpenseCategoryId" + ExpenseCategoryId);
            //stringBuilder.Append("ExpenseId" + ExpenseId);
            stringBuilder.Append("BranchId" + BranchId);
            stringBuilder.Append("IsArchived" + IsArchived);
            stringBuilder.Append("SearchText" + SearchText);
            return base.ToString();
        }
    }
}