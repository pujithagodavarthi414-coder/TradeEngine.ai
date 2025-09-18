using System;

namespace Btrak.Models.Roster
{
    public class RosterAdhocRequirement
    {
        public DateTime ReqDate { get; set; }
        public TimeSpan ReqFromTime { get; set; }
        public TimeSpan ReqToTime { get; set; }
        public int NoOfEmployeeRequired { get; set; }
        public Guid[] EmployeeSpecifcation { get; set; }
    }
}
