using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.PayRoll
{
    public class IncomeSalaryStatementDetailsOutputModel
    {
        public string MonthlyIncome { get; set; }
        public string AdhocIncome { get; set; }
        public string Deductions { get; set; }
        public string TotalIncome { get; set; }
        public string EmployeeNumber { get; set; }
        public string EmployeeName { get; set; }
        public string ProfileImage { get; set; }
        public bool IsArchived { get; set; }
        public Guid UserId { get; set; }
        public string PANNumber { get; set; }
        public string Gender { get; set; }
        public string Location { get; set; }
        public string JoinedDate { get; set; }
        public string DateofBirth { get; set; }
        public string DateOfLeavingService { get; set; }
    }
}
