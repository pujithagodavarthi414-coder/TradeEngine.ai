using System;

namespace Btrak.Models.Expenses
{
    public class ExpenseStatusSearchCriteriaInputModel
    {
        public Guid? ExpenseStatusId { get; set; }
        public bool? IsArchived { get; set; }
        public string SearchText { get; set; }
        public string ExpenseStatusName { get; set; }
    }

    public class ApprovedUserModel
    {
        public Guid? UserId { get; set; }
        public string UserName { get; set; }
        public string Email { get; set; }
    }
}
