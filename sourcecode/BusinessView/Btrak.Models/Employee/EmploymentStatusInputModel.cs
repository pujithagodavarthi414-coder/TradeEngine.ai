using BTrak.Common;
using System;
using System.ComponentModel.DataAnnotations;
using System.Text;

namespace Btrak.Models.Employee
{
    public class EmploymentStatusInputModel : InputModelBase
    {
        public EmploymentStatusInputModel() : base(InputTypeGuidConstants.EmploymentContractInputCommandTypeGuid)
        {
        }
       
        public Guid? EmploymentStatusId { get; set; }
        [StringLength(50)]
        public string EmploymentStatusName { get; set; }
        public bool IsPermanent { get; set; }
        public bool? IsArchived { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(" EmploymentStatusId = " + EmploymentStatusId);
            stringBuilder.Append(", EmploymentStatusName = " + EmploymentStatusName);
            stringBuilder.Append(", IsPermanent = " + IsPermanent);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}
