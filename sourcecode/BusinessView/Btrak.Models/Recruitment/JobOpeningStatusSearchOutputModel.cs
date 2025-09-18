using System;

namespace Btrak.Models.Recruitment
{
    public class JobOpeningStatusSearchOutputModel
    {
        public Guid? JobOpeningStatusId { get; set; }
        public string Status { get; set; }
        public int Order { get; set; }
        public Guid? CompanyId { get; set; }
        public bool? IsArchived { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public DateTime? InActiveDateTime { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public byte[] TimeStamp { get; set; }
        public int? TotalCount { get; set; }
        public string StatusColour { get; set; }
    }
}
