using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.PayRoll
{
    public class EmployeeCreditorDetailsSearchInputModel: SearchCriteriaInputModelBase
    {
        public EmployeeCreditorDetailsSearchInputModel() : base(InputTypeGuidConstants.EmployeeCreditorDetailsSearchInputCommandTypeGuid)
        {
        }

        public Guid? EmployeeCreditorDetailsId { get; set; }
        public Guid? EmployeeId { get; set; }
        public bool? UseForPerformaInvoice { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("EmployeeCreditorDetailsId = " + EmployeeCreditorDetailsId);
            stringBuilder.Append("EmployeeId = " + EmployeeId);
            stringBuilder.Append(",IsArchived = " + IsArchived);
            stringBuilder.Append(",SearchText = " + SearchText);
            return stringBuilder.ToString();
        }
    }
}
