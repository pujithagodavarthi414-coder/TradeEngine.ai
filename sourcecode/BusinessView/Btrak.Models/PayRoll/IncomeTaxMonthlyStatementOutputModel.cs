using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.PayRoll
{
    public class IncomeTaxMonthlyStatementOutputModel
    {
        public string EmployeeNumber { get; set; }
        public string EmployeeName { get; set; }
        public string JoinedDate { get; set; }
        public string PANNumber { get; set; }
        public float TaxableIncome { get; set; }
        public float IncomeTax { get; set; }
        public float Cess { get; set; }
        public float DirectTaxableIncome { get; set; }
        public float TDSIncomeTax { get; set; }
        public float TotalTax { get; set; }
        public int TotalRecordsCount { get; set; }
    }
}
