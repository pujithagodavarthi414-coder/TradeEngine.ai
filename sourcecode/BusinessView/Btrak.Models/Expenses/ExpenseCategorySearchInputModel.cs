using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.Expenses
{
    public class ExpenseCategorySearchInputModel : SearchCriteriaInputModelBase
    {
        public ExpenseCategorySearchInputModel() : base(InputTypeGuidConstants.ExpenseCategorySearchInputCommandTypeGuid)
        {
        }
        public Guid? ExpenseCategoryId { get; set; }
        public string CategoryName { get; set; }
        public string Description { get; set; }
        public string AccountCode { get; set; }
        public bool? IsSubCategory { get; set; } = null;

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("ExpenseCategoryId = " + ExpenseCategoryId);
            stringBuilder.Append("CategoryName = " + CategoryName);
            stringBuilder.Append("Description = " + Description);
            stringBuilder.Append("AccountCode = " + AccountCode);
            stringBuilder.Append("IsSubCategory" + IsSubCategory);
            stringBuilder.Append("IsActive" + IsActive);
            stringBuilder.Append("TimeStamp" + TimeStamp);
            return stringBuilder.ToString();
        }
        
    }
}
