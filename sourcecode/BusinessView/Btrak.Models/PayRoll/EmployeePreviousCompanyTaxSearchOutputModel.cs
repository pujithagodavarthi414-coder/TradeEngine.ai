using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.PayRoll
{
    public class EmployeePreviousCompanyTaxSearchOutputModel
    {
        public Guid? EmployeePreviousCompanyTaxId { get; set; }
        public bool? IsArchived { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public DateTime? InActiveDateTime { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public byte[] TimeStamp { get; set; }
        public int? TotalCount { get; set; }
        public Guid? EmployeeId { get; set; }
        public string EmployeeName { get; set; }
        public decimal? TaxAmount { get; set; }
    }
}
