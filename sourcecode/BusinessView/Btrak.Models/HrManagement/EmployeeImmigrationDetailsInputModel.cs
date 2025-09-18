using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.HrManagement
{
    public class EmployeeImmigrationDetailsInputModel : InputModelBase
    {
        public EmployeeImmigrationDetailsInputModel() : base(InputTypeGuidConstants.EmployeeImmigrationSearchInputCommandTypeGuid)
        {
        }

        public Guid? EmployeeImmigrationId { get; set; }
        public string SearchText { get; set; }
        public Guid? EmployeeId { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("EmployeeId = " + EmployeeId);
            stringBuilder.Append(", SearchText = " + SearchText);
            stringBuilder.Append(",EmployeeImmigrationId = " + EmployeeImmigrationId);
            return stringBuilder.ToString();
        }
    }
}