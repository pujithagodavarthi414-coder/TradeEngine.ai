using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.ActivityTracker
{
    public class EmployeeSearchOutputModel : InputModelBase
    {
        public EmployeeSearchOutputModel() : base(InputTypeGuidConstants.EmployeeSearchOutputCommandTypeGuid)
        {

        }
        public Guid? UserId { get; set; }
        public string Name { get; set; }
        public Guid? RoleId { get; set; }
        public Guid? BranchId { get; set; }
        public string Role { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", UserId" + UserId);
            stringBuilder.Append(", Name" + Name);
            stringBuilder.Append(", RoleId" + RoleId);
            stringBuilder.Append(", BranchId" + BranchId);
            return stringBuilder.ToString();
        }

    }
}
