using System;

namespace Btrak.Models.PayRoll
{
    public class RateTagRoleBranchConfigurationApiReturnModel
    {
        public Guid? RateTagRoleBranchConfigurationId { get; set; }
        public Guid? RoleId { get; set; }
        public Guid? BranchId { get; set; }
        public bool? IsArchived { get; set; }
        public int? Priority { get; set; }
        public DateTime? StartDate { get; set; }
        public DateTime? EndDate { get; set; }
        public string RoleName { get; set; }
        public string BranchName { get; set; }
        public byte[] TimeStamp { get; set; }
        public int? TotalCount { get; set; }
    }
}
