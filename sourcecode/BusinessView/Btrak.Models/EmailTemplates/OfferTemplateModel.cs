using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.EmailTemplates
{
    public class OfferTemplateModel
    {
        public Guid Id { get; set; }

        public Guid EmployeeId { get; set; }
        public string EmployeeName { get; set; }
        public Guid TemplateTypeId { get; set; }
        public string Address { get; set; }
        public string Phone { get; set; }
        public string JobTitle { get; set; }
        public string PackageInWords { get; set; }
        public int PackageInLakhs { get; set; }
        public int SpecialAllowance { get; set; }
        public DateTime ReportDateTime { get; set; }
        public string ReportDate { get; set; }
        public int BasicSalary { get; set; }
        public int HRA { get; set; }
        public int ConveyanceAllowance { get; set; }
        public int MedicalAllowance { get; set; }
        public int YearlyBonus { get; set; }
        public int GrossSalary { get; set; }
        public int EmployerPF { get; set; }
        public int CTC { get; set; }
        public string CurrentDate { get; set; }
        public DateTime CreatedDateTime { get; set; }
        public Guid CreatedByUserId { get; set; }
        public DateTime UpdatedDateTime { get; set; }
        public Guid UpdatedByUserId { get; set; }
    }
}
