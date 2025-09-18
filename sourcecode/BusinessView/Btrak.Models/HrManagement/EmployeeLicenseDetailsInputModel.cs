using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.HrManagement
{
    public class EmployeeLicenseDetailsInputModel : InputModelBase
    {
        public EmployeeLicenseDetailsInputModel() : base(InputTypeGuidConstants.EmployeeLicenceSearchInputCommandTypeGuid)
        {
        }

        public Guid? EmployeeId { get; set; }
        public string SearchText { get; set; }
        public string EmployeeLicenceId { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("EmployeeId = " + EmployeeId);          
            stringBuilder.Append(", SearchText = " + SearchText);
            stringBuilder.Append(",EmployeeLicenceId = " + EmployeeLicenceId);
            return stringBuilder.ToString();
        }

    }
}