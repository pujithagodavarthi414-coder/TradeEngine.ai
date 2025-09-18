using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.PayRoll
{
    public class SalaryRegisterOutputModel
    {
        public string EmployeeNumber { get; set; }
        public string EmployeeName { get; set; }
        public string ProfileImage { get; set; }
        public Guid UserId { get; set; }
        public string JoinedDate { get; set; }
        public string MonthValue { get; set; }
        public float BonusAmount { get; set; }
        public float ActualNetPayAmount { get; set; }
        public bool IsArchived { get; set; }
        public int TotalRecordsCount { get; set; }
    }
}
