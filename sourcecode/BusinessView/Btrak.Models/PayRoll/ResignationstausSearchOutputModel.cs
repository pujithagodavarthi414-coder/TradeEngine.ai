using System;

namespace Btrak.Models.PayRoll
{
    public class ResignationstausSearchOutputModel
    {
        public Guid? ResignationStatusId { get; set; }
        public string StatusName { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public DateTime? InActiveDateTime { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public byte[] TimeStamp { get; set; }
        public int? TotalCount { get; set; }
    }
}
