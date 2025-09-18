using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Text;

namespace Btrak.Models.ActivityTracker
{
    public class EmployeeSearchInputModel : InputModelBase
    {
        public EmployeeSearchInputModel() : base(InputTypeGuidConstants.EmployeeSearchInputCommandTypeGuid)
        {

        }
        public List<Guid> RoleId { get; set; }
        public string RoleIdXml { get; set; }
        public List<Guid> BranchId { get; set; }
        public string BranchIdXml { get; set; }
        public bool? IsAllEmployee { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", RoleId" + RoleId);
            stringBuilder.Append(", RoleIdXml" + RoleIdXml);
            stringBuilder.Append(", BranchId" + BranchId);
            stringBuilder.Append(", BranchXml" + BranchIdXml);
            stringBuilder.Append(", IsAllEmployee" + IsAllEmployee);
            return stringBuilder.ToString();
        }
    }
}
