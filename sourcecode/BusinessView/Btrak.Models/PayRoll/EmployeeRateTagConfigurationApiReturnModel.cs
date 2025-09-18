using System;

namespace Btrak.Models.PayRoll
{
    public class EmployeeRateTagConfigurationApiReturnModel
    {
        public Guid? RateTagEmployeeId { get; set; }
        public DateTime? StartDate { get; set; }
        public DateTime? EndDate { get; set; }
        public bool IsInHerited { get; set; }
        public bool? IsOverRided { get; set; }
        public Guid? RateTagRoleBranchConfigurationId { get; set; }
        public string EmployeeName { get; set; }
        public Guid? RoleId { get; set; }
        public Guid? BranchId { get; set; }
        public string RoleName { get; set; }
        public string BranchName { get; set; }
        public int? Priority { get; set; }
    }
}
