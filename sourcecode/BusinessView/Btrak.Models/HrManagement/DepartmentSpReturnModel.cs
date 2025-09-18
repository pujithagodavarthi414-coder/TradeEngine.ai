using System;

namespace Btrak.Models.HrManagement
{
    public class DepartmentSpReturnModel
    {
        public Guid? DepartmentId { get; set; }
        public string DepartmentName { get; set; }
        public DateTime CreatedDateTime { get; set; }
        public DateTime? InActiveDateTime { get; set; }
        public byte[] TimeStamp { get; set; }
        public int TotalCount { get; set; }
    }
}
