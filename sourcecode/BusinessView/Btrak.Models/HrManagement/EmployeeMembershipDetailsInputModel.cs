using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.HrManagement
{
    public class EmployeeMembershipDetailsInputModel :InputModelBase
    {
        public EmployeeMembershipDetailsInputModel() : base(InputTypeGuidConstants.EmployeeMembershipSearchInputCommandTypeGuid)
        {
        }

        public Guid? EmployeeMembershipid { get; set; }
        public string SearchText { get; set; }
        public Guid? EmployeeId { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("EmployeeId = " + EmployeeId);
            stringBuilder.Append(", SearchText = " + SearchText);
            stringBuilder.Append(",EmployeeMembershipid = " + EmployeeMembershipid);
            return stringBuilder.ToString();
        }
    }
}