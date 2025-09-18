using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.PayRoll
{
    public class RegisterOfWagesOutputModel
    {
        public string EmployeeNumber { get; set; }
        public string EmployeeName { get; set; }
        public string ProfileImage { get; set; }
        public Guid UserId { get; set; }
        public bool IsArchived { get; set; }
        public string JoinedDate { get; set; }
        public float EmployeeSalary { get; set; }
        public float ActualEmployeeSalary { get; set; }
        public float ActualDeduction { get; set; }
        public float ActualPaidAmount { get; set; }
        public string DateOfPayment { get; set; }
        public int TotalRecordsCount { get; set; }
    }
}
