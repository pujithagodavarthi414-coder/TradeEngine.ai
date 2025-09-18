using System;
using System.Collections.Generic;

namespace Btrak.Models.Expenses
{
    public class ExpenseMailModel
    {
        public string[] TO { get; set; }
        public string[] CC { get; set; }
        public string[] BCC { get; set; }
        public string ExpenseName { get; set; }
        public string ExpenseStatus { get; set; }
        public List<ExpenseCategoryConfigurationModel> ExpenseCategoriesConfigurations { get; set; }
        public string CurrencySymbol { get; set; }
        public decimal? TotalAmount { get; set; }
        public DateTime? ExpenseDate { get; set; }
        public string MerchantName { get; set; }
    }
}
