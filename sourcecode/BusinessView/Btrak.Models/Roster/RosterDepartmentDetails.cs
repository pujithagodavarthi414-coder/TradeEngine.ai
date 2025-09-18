using System;

namespace Btrak.Models.Roster
{
    public class RosterDepartmentDetails
    {
        public string DepartmentName { get; set; }
        public Guid DepartmentId { get; set; }
        public Guid? ShiftId { get; set; }
        public int NoOfEmployeeRequired { get; set; }
        public Guid[] EmployeeSpecifcation { get; set; }

    }
}
