using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.Roster
{
    public class RosterInputModel : InputModelBase
    {
        public RosterInputModel() : base(InputTypeGuidConstants.EmployeeRatesheetDetailsInputCommandTypeGuid)
        {
        }
        public Guid? RequestId { get; set; }
        public RosterBasicDetails rosterBasicDetails { get; set; }
        public List<WorkingDays> workingDays { get; set; }
        public List<RosterShiftDetails> rosterShiftDetails { get; set; }
        public List<RosterDepartmentDetails> rosterDepartmentDetails { get; set; }
        public List<RosterAdhocRequirement> rosterAdhocRequirement { get; set; }
        public int TimeZone{ get; set; }
    }

    public class WorkingDays
    {
        public DateTime ReqDate { get; set; }
        public bool IsHoliday { get; set; }
    }
}
