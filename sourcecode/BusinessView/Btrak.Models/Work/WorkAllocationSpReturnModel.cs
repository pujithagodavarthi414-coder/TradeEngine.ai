using System;

namespace Btrak.Models.Work
{
    public class WorkAllocationSpReturnModel
    {
        public Guid UserId { get; set; }
        public string UserName { get; set; }
        public decimal WorkAllocated { get; set; }
        public decimal MinWork { get; set; }
        public decimal MaxWork { get; set; }
        public DateTime? MaxDeadLineDate { get; set; }
        public DateTime? Date { get; set; }
        public bool IsSupport { get; set; }
        public string Color { get; set; }
    }
}
