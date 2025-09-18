using System;

namespace Btrak.Models.Branch
{
    public class BranchSpReturnModel
    {
        public Guid? BranchId { get; set; }
        public Guid? CompanyId { get; set; }
        public string BranchName { get; set; }
        public Guid RegionId { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public DateTime CreatedDateTime { get; set; }
        public DateTime? InActiveDateTime { get; set; }
        public byte[] TimeStamp { get; set; }
        public int TotalCount { get; set; }
        public bool IsArchived { get; set; }
        public string RegionName { get; set; }
    }
}
                   
