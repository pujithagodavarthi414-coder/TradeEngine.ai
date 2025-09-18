using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.PayRoll
{
    public class IncomeSalaryStatementOutputModel
    {
        public string RunMonth { get; set; }
        public float ActualPaidAmount { get; set; }
        public float ComponentTotal { get; set; }
        public string EmployeeName { get; set; }
        public string ProfileImage { get; set; }
        public bool? IsInResignation { get; set; }
        public float ActualComponentAmount { get; set; }
        public string ComponentName { get; set; }
        public bool IsDeduction { get; set; }
        public bool? IsBonus { get; set; }
        public bool? IsLoanEmi { get; set; }
        public Guid EmployeeId { get; set; }

    }
}
