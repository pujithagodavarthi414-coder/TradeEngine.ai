using System;
using System.Text;

namespace Btrak.Models.Expenses
{
    public class ExpenseCategoryModel
    {
        public Guid? ExpenseCategoryId { get; set; }
        public string CategoryName { get; set; }
        public string Description { get; set; }
        public string AccountCode { get; set; }
        public bool IsSubCategory { get; set; }
        public byte[] TimeStamp { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("ExpenseCategoryId =" + ExpenseCategoryId);
            stringBuilder.Append(", CategoryName =" + CategoryName);
            stringBuilder.Append(", Description =" + Description);
            stringBuilder.Append(", AccountCode =" + AccountCode);
            stringBuilder.Append(", IsSubCategory =" + IsSubCategory);
            stringBuilder.Append(", Timestamp =" + TimeStamp);
            return stringBuilder.ToString();
        }
    }
}
