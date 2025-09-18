using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.BillingManagement
{
    public class UpsertExpenseCategoryInputModel : InputModelBase
    {

        public UpsertExpenseCategoryInputModel() : base(InputTypeGuidConstants.UpsertExpenseCategoryInputCommandTypeGuid)
        {
        }
        public Guid? ExpenseCategoryId { get; set; }
        //public Guid? ExpenseId { get; set; }
        public string CategoryName { get; set; }
        public string Description { get; set; }
        public bool IsArchived { get; set; }
        public byte[] TimeStamp { get; set; }
        public int TotalCount { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("ExpenseCategoryId" + ExpenseCategoryId);
            //stringBuilder.Append("ExpenseId" + ExpenseId);
            stringBuilder.Append("CategoryName" + CategoryName);
            stringBuilder.Append("Description" + Description);
            stringBuilder.Append("IsArchived" + IsArchived);
            stringBuilder.Append("TimeStamp" + TimeStamp);
            stringBuilder.Append("TotalCount" + TotalCount);
            return base.ToString();
        }
    }
}
