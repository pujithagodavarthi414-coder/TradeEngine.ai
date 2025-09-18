using System;
using System.Text;

namespace Btrak.Models.BillingManagement
{
    public class ExpenseCategoryOutputModel
    {
        public Guid? ExpenseCategoryId { get; set; }
        //public Guid? ExpenseId { get; set; }
        public string CategoryName { get; set; }
        public string Description { get; set; }
        public int VersionNumber { get; set; }
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
            stringBuilder.Append("VersionNumber" + VersionNumber);
            stringBuilder.Append("IsArchived" + IsArchived);
            stringBuilder.Append("TimeStamp" + TimeStamp);
            stringBuilder.Append("TotalCount" + TotalCount);
            return base.ToString();
        }
    }
}