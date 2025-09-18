using System;
using System.Collections.Generic;

namespace Btrak.Models.HrManagement
{
    public class EmployeeShiftSearchOutputModel
    {
        public Guid? ShiftTimingId { get; set; }
        public Guid? EmployeeShiftId { get; set; }
        public Guid? BranchId { get; set; }
        public string ShiftName { get; set; }
        public Guid? EmployeeId { get; set; }
        public DateTime? ActiveFrom { get; set; }
        public DateTime? ActiveTo { get; set; }
        public bool? IsArchived { get; set; }
        public int? TotalCount { get; set; }
        public byte[] TimeStamp { get; set; }
        //public List<ShiftWeekSearchOutputModel> ShiftWeek { get; set; }
        //public List<ShiftExceptionSearchOutputModel> ShiftException { get; set; }
    }
}
