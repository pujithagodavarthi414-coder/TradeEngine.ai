using System;

namespace Btrak.Models.MasterData
{
    public class SpecificDayOutPutModel
    {
        public Guid? SpecificDayId { get; set; }
        public string Reason { get; set; }
        public bool? Archived { get; set; }
        public Guid? CompanyId { get; set; }
        public DateTime? Date { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public Guid? UpdatedByUserId { get; set; }
        public DateTime? UpdatedDateTime { get; set; }
        public int? TotalCount { get; set; }
        public byte[] TimeStamp { get; set; }
    }
}
