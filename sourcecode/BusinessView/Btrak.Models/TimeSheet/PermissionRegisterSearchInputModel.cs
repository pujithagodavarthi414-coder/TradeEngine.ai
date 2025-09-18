using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.TimeSheet
{
    public class PermissionRegisterSearchInputModel :SearchCriteriaInputModelBase
    {
        public PermissionRegisterSearchInputModel() : base(InputTypeGuidConstants.PermissionRegisterSearchInputCommandTypeGuid)
        {
        }

        public Guid? EmployeeId { get; set; }
        public DateTime? DateFrom { get; set; }
        public DateTime? DateTo { get; set; }
        public Guid? EntityId { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("EmployeeId = " + EmployeeId);
            stringBuilder.Append(", DateFrom = " + DateFrom);
            stringBuilder.Append(", DateTo = " + DateTo);
            return stringBuilder.ToString();
        }
    }
}
