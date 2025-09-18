using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.PayRoll
{
    public class EmployeeAccountDetailsSearchInputModel : SearchCriteriaInputModelBase
    {
        public EmployeeAccountDetailsSearchInputModel() : base(InputTypeGuidConstants.EmployeeAccountDetailsSearchInputCommandTypeGuid)
        {
        }

        public Guid? EmployeeAccountDetailsId { get; set; }
        public Guid? EmployeeId { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("EmployeeAccountDetailsId = " + EmployeeAccountDetailsId);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(",SearchText = " + SearchText);
            return stringBuilder.ToString();
        }
    }
}
