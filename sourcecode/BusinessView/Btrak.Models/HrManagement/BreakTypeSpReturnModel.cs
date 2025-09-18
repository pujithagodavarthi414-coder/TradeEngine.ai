using System;

namespace Btrak.Models.HrManagement
{
    public class BreakTypeSpReturnModel
    {
        public Guid? BreakTypeId { get; set; }
        public string BreakName { get; set; }
        public bool IsPaid { get; set; }
        public DateTime CreatedDateTime { get; set; }
        public DateTime? InActiveDateTime { get; set; }
        public bool IsArchived { get; set; }
        public byte[] TimeStamp { get; set; }
        public int TotalCount { get; set; }
    }
}