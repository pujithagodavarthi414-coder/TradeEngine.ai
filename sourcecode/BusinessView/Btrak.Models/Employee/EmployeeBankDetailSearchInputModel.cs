using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.Employee
{
    public class EmployeeBankDetailSearchInputModel : InputModelBase
    {
        public EmployeeBankDetailSearchInputModel() : base(InputTypeGuidConstants.EmployeeBankDetailSearchInputCommandTypeGuid)
        {
        }

        public Guid? EmployeeId { get; set; }
        public Guid? EmployeeBankDetailsId { get; set; }
        public string SearchText { get; set; }
        public string AccountNameSearchText { get; set; }
        public string AccountNumberSearchText { get; set; }
        public string BankNameSearchText { get; set; }
        public string BranchNameSearchText { get; set; }
        public DateTime? EffectiveFrom { get; set; }
        public DateTime? EffectiveTo { get; set; }
        public bool? IsArchived { get; set; }
        public string SortBy { get; set; }
        public bool SortDirectionAsc { get; set; }
        public string SortDirection => SortDirectionAsc ? "ASC" : "DESC";
        public int PageSize { get; set; } = 1000;
        public int PageNumber { get; set; } = 1;
        public int Skip => (PageNumber == 1 || PageNumber == 0) ? 0 : PageSize * (PageNumber - 1);

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("EmployeeId = " + EmployeeId);
            stringBuilder.Append(", SearchText = " + SearchText);
            stringBuilder.Append(", AccountNameSearchText = " + AccountNameSearchText);
            stringBuilder.Append(", AccountNumberSearchText = " + AccountNumberSearchText);
            stringBuilder.Append(", BankNameSearchText = " + BankNameSearchText);
            stringBuilder.Append(", BranchNameSearchText = " + BranchNameSearchText);
            stringBuilder.Append(", EffectiveFrom = " + EffectiveFrom);
            stringBuilder.Append(", EffectiveTo = " + EffectiveTo);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", SortBy = " + SortBy);
            stringBuilder.Append(", SortDirectionAsc = " + SortDirectionAsc);
            stringBuilder.Append(", PageSize = " + PageSize);
            stringBuilder.Append(", PageNumber = " + PageNumber);
            return stringBuilder.ToString();
        }
    }
}