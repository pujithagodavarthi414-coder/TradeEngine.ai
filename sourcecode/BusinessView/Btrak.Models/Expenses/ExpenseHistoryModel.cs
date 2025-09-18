using System;

namespace Btrak.Models.Expenses
{
    public class ExpenseHistoryModel 
    {
        public Guid? ExpenseHistoryId { get; set; }
        public Guid? ExpenseId { get; set; }
        public string ExpenseName { get; set; }
        public string OldValue { get; set; }
        public string NewValue { get; set; }
        public string FieldName { get; set; }
        public string Description { get; set; }
        public string FullName { get; set; }
        public Guid CreatedByUserId { get; set; }
        public string ProfileImage { get; set; }
        public DateTime CreatedDateTime { get; set; }
        public int TotalCount { get; set; }
    }
}
