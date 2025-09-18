using System;

namespace Btrak.Models.Roster
{
    public class RosterEmployeeBudget
    {
        public Guid EmployeeId { get; set; }
        public float HourlyRate {get;set;}
        public float RateType { get; set; }
    }
}
