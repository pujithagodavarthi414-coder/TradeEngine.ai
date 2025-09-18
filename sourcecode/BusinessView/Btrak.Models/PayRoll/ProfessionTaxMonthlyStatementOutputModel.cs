using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.PayRoll
{
    public class ProfessionTaxMonthlyStatementOutputModel
    {
        public string EmployeeNumber { get; set; }
        public string EmployeeName { get; set; }
        public string ProfileImage { get; set; }
        public Guid UserId { get; set; }
        public float ProfBasic { get; set; }
        public float Amount { get; set; }
        public string SummaryJson { get; set; }
        public bool IsArchived { get; set; }
        public int TotalCount { get; set; }
    }
}
