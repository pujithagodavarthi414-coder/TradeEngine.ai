using System;

namespace Btrak.Models.Branch
{
    public class BranchApiDropdownReturnModel
    {
        public Guid? BranchId { get; set; }
        public string BranchName { get; set; }
        public DateTime CreatedDateTime { get; set; }
        public byte[] TimeStamp { get; set; }
        public int TotalCount { get; set; }
        public Guid? CompanyId { get; set; }
        public Guid? CreatedByUserId { get; set; }
    }
}
