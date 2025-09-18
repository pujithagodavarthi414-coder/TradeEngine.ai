using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.HrManagement
{
    public class EmployeeEducationDetailsInputModel : InputModelBase
    {
        public EmployeeEducationDetailsInputModel() : base(InputTypeGuidConstants.EmployeeEducationSearchInputCommandTypeGuid)
        {
        }

        public Guid? EmployeeEducationId { get; set; }
        public string SearchText { get; set; }
        public Guid? EmployeeId { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("EmployeeId = " + EmployeeId);
            stringBuilder.Append(", SearchText = " + SearchText);
            stringBuilder.Append(",EmployeeEducationId = " + EmployeeEducationId);
            return stringBuilder.ToString();
        }
    }
}
