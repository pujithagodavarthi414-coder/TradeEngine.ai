using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.ActivityTracker
{
    public class TimeUsageOfApplicationSearchInputModel : SearchCriteriaInputModelBase
    {
        public TimeUsageOfApplicationSearchInputModel() : base(InputTypeGuidConstants.TimeUsageOfApplicationSearchInputCommandTypeGuid)
        {

        }
        public List<Guid> UserId { get; set; }
        public string UserIdXml { get; set; }
        public List<Guid> RoleId { get; set; }
        public string RoleIdXml { get; set; }
        public List<Guid> BranchId { get; set; }
        public string BranchIdXml { get; set; }
        public DateTime DateFrom { get; set; }
        public DateTime DateTo { get; set; }
        public bool IsForDashboard { get; set; }
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", UserId" + UserId);
            stringBuilder.Append(",UserIdXml" + UserIdXml);
            stringBuilder.Append(", RoleId" + RoleId);
            stringBuilder.Append(", RoleIdXml" + RoleIdXml);
            stringBuilder.Append(", RoleId" + BranchId);
            stringBuilder.Append(", RoleIdXml" + BranchIdXml);
            stringBuilder.Append(",DateFrom" + DateFrom);
            stringBuilder.Append(", DateTo = " + DateTo);
            return stringBuilder.ToString();
        }
    }
}
