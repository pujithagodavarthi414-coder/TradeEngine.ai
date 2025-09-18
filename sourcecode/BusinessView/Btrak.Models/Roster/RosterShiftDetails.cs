using System;

namespace Btrak.Models.Roster
{
    public class RosterShiftDetails
    {
        public string shiftName { get; set; }
        public Guid shiftId { get; set; }
        public int NoOfEmployeeRequired { get; set; }
        public Guid[] EmployeeSpecifcation { get; set; }
    }
}
