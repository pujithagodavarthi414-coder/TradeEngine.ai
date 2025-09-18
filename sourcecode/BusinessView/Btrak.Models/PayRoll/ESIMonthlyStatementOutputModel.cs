using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.PayRoll
{
    public class ESIMonthlyStatementOutputModel
    {
        public Guid EmployeeId { get; set; }
        public string BranchName { get; set; }
        public string ESINumber { get; set; }
        public string EmployeeNumber { get; set; }
        public string EmployeeName { get; set; }
        public string ProfileImage { get; set; }
        public Guid UserId { get; set; }
        public float ESIGross { get; set; }
        public float EmployeeContribusion { get; set;}
        public float EmployeerContribusion { get; set; }
        public float TotalContribution { get; set; }
        public float ESIGrossGrandTotal { get; set; }
        public float EmployeeContributionGrandTotal { get; set; }
        public float EmployeerContributionGrandTotal { get; set; }
        public float TotalContributionGrandTotal { get; set; }
        public float ESIGrossByBranch { get; set; }
        public float EmployeeContributionByBranch { get; set; }
        public float EmployeerContributionByBranch { get; set; }
        public float TotalContributionByBranch { get; set; }
        public bool IsArchived { get; set; }
        public int TotalRecordsCount { get; set; }

    }
}
