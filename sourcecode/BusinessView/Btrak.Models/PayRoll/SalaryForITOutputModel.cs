using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.PayRoll
{
    public class SalaryForITOutputModel
    {
        public Guid EmployeeId { get; set; }
        public string EmployeeName { get; set; }
        public string ProfileImage { get; set; }
        public Guid UserId { get; set; }
        public string PANNumber { get; set; }
        public string DateofBirth { get; set; }
        public string SectionName { get; set; }
        public string ParentSectionName { get; set; }
        public bool IsParent { get; set; }
        public int? Age { get; set; }
        public float? MaxInvestment { get; set; }
        public float? Investment { get; set; }
        public float? Tax { get; set; }
        public float? NetSalary { get; set; }
        public float? TaxableAmount { get; set; }
        public float? TotalTax { get; set; }
    }
}
