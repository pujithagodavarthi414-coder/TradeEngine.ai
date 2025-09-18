using System;

namespace Btrak.Models.Recruitment
{
    public class SourceSearchOutputModel
    {
        public Guid? SourceId { get; set; }
        public string Name { get; set; }
        public bool IsReferenceNumberNeeded { get; set; }
        public Guid? CompanyId { get; set; }
        public bool? IsArchived { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public DateTime? InActiveDateTime { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public byte[] TimeStamp { get; set; }
        public int? TotalCount { get; set; }
    }
}
