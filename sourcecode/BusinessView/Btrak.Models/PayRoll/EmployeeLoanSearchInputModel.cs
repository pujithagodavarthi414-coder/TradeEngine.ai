using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.PayRoll
{
    public class EmployeeLoanSearchInputModel : SearchCriteriaInputModelBase
    {
        public EmployeeLoanSearchInputModel() : base(InputTypeGuidConstants.EmployeeLoanSearchInputCommandTypeGuid)
        {
        }

        public Guid? EmployeeLoanId { get; set; }
        public Guid? EmployeeId { get; set; }
        public bool? IsApproved { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("EmployeeLoanId = " + EmployeeLoanId);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", IsApproved = " + IsApproved);
            stringBuilder.Append(",SearchText = " + SearchText);
            return stringBuilder.ToString();
        }
    }
}
