using System;

namespace Btrak.Models.HrManagement
{
    public class PayGradeSpReturnModel
    {
        public Guid? PayGradeId { get; set; }
        public string PayGradeName { get; set; }
        public DateTime CreatedDateTime { get; set; }
        public DateTime? InActiveDateTime { get; set; }
        public bool IsArchived { get; set; }
        public byte[] TimeStamp { get; set; }
        public int TotalCount { get; set; }
    }
}
