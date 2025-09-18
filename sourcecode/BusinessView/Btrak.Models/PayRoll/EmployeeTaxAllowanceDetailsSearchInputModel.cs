using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.PayRoll
{
    public class EmployeeTaxAllowanceDetailsSearchInputModel : SearchCriteriaInputModelBase
    {
        public EmployeeTaxAllowanceDetailsSearchInputModel() : base(InputTypeGuidConstants.EmployeeTaxAllowanceDetailsSearchInputCommandTypeGuid)
        {
        }

        public Guid? EmployeeTaxAllowanceId { get; set; }
        public Guid? EmployeeId { get; set; }
        

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(" EmployeeTaxAllowanceId= " + EmployeeTaxAllowanceId);
            stringBuilder.Append(" EmployeeId= " + EmployeeId);
            stringBuilder.Append(", SearchText= " + SearchText);
            stringBuilder.Append(", IsArchived= " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}
