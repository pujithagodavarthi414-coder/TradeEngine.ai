using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.HrManagement
{
    public class EmployeeSalaryDetailsInputModel : InputModelBase
    {
        public EmployeeSalaryDetailsInputModel() : base(InputTypeGuidConstants.EmployeeSalarySearchInputCommandTypeGuid)
        {
        }

        public Guid? EmployeeSalaryDetailId { get; set; }
        public string SearchText { get; set; }
        public Guid? EmployeeId { get; set; }
        public bool IsArchived { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("EmployeeId = " + EmployeeId);
            stringBuilder.Append(", SearchText = " + SearchText);
            stringBuilder.Append(",EmployeeSalaryDetailId = " + EmployeeSalaryDetailId);
            stringBuilder.Append(",IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}