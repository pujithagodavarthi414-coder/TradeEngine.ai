using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.Expenses
{
    public class UpsertExpenseCategoryApiInputModel : InputModelBase
    {
        public UpsertExpenseCategoryApiInputModel() : base(InputTypeGuidConstants.UpsertExpenseCategroyInputCommandTypeGuid)
        {
        }
        
        public Guid? ExpenseCategoryId { get; set; }
        public string ExpenseCategoryName { get; set; }
        public string AccountCode { get; set; }
        public string Description { get; set; }
        public byte[] Timestamp { get; set; }
        public bool IsSubCategory { get; set; }
        public string ImageUrl { get; set; }
        public bool IsActive { get; set; }
        public bool? IsArchived { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("ExpenseCategoryId = " + ExpenseCategoryId);
            stringBuilder.Append(", ExpenseCategoryName = " + ExpenseCategoryName);
            stringBuilder.Append(", AccountCode = " + AccountCode);
            stringBuilder.Append(", Description = " + Description);
            stringBuilder.Append(", Timestamp = " + Timestamp);
            stringBuilder.Append(", IsSubCategory = " + IsSubCategory);
            stringBuilder.Append(", ImageUrl = " + ImageUrl);
            stringBuilder.Append(", IsActive = " + IsActive);
            return stringBuilder.ToString();
        }
    }
}
