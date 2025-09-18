using System;

namespace Btrak.Models.TVA
{
    public class TVASearchOutputModel
    {
        public Guid Id { get; set; }
        public DateTime? StartDate { get; set; }
        public DateTime? EndDate { get; set; }
        public decimal TVAValue { get; set; }
        public Guid CreatedByUserId { get; set; }
        public DateTime CreatedDateTime { get; set; }
        public string CreatedBy { get; set; }
        public byte[] TimeStamp { get; set; }
    }
}
