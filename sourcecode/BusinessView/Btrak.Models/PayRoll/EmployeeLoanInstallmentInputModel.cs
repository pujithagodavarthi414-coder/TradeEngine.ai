using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.PayRoll
{
    public class EmployeeLoanInstallmentInputModel : InputModelBase
    {
        public EmployeeLoanInstallmentInputModel() : base(InputTypeGuidConstants.EmployeeLoanInstallmentInputCommandTypeGuid)
        {
        }
        
        public Guid? Id { get; set; }
        public Guid? EmployeeId { get; set; }
        public Guid? EmployeeLoanId { get; set; }
        public decimal PrincipalAmount { get; set; }
        public decimal InstallmentAmount { get; set; }
        public decimal PaidAmount { get; set; }
        public DateTime? InstallmentDate { get; set; }
        public bool IsTobePaid { get; set; }
        public bool IsArchived { get; set; }
        public Guid? UserId { get; set; }
    }
}
