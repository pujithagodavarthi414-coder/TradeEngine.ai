using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.HrManagement
{
    public class EmployeeEmergencyDetailsDetailsInputModel : InputModelBase
    {
        public EmployeeEmergencyDetailsDetailsInputModel() : base(InputTypeGuidConstants.EmployeeEmergencyContactDetailsSearchInputCommandTypeGuid)
        {
        }

        public string SearchText { get; set; }
        public Guid? EmployeeId { get; set; }

        public Guid? EmergencyContactId { get; set; }
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("EmployeeId = " + EmployeeId);
            stringBuilder.Append(", SearchText = " + SearchText);
            stringBuilder.Append(", EmergencyContactId = " + EmergencyContactId);
            return stringBuilder.ToString();
        }
    }
}