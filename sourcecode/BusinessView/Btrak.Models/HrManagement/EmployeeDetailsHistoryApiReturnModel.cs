using System;

namespace Btrak.Models.HrManagement
{
    public class EmployeeDetailsHistoryApiReturnModel
    {
        public Guid? EmployeeHistoryId { get; set; }
        public DateTime CreatedDateTime { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public string Description { get; set; }
        public string Category { get; set; }
        public string ProfileImage { get; set; }
        public string UserName { get; set; }
        public int? TotalCount { get; set; }
    }
}
