using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.Roster
{
    public class EmployeeBudget
    {
        public DateTime BudgetDate { get; set; }
        public DateTime? JoiningDate { get; set; }
        public Guid EmployeeId { get; set; }
        public string EmployeeName { get; set; }
        public string EmployeeProfileImage { get; set; }
        public Guid? ShiftId { get; set; }
        public Guid? DepartmentId { get; set; }
        public string DepartmentName { get; set; }
        public decimal TotalBudget { get; set; }
        public decimal BudgetPerHour { get; set; }
        public string CurrencyCode { get; set; }
        public TimeSpan? FromTime { get; set; }
        public TimeSpan? ToTime { get; set; }
        public bool IsPermanent { get; set; }
    }
}
