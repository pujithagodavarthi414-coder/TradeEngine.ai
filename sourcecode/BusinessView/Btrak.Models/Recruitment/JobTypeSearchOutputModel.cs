using System;

namespace Btrak.Models.Recruitment
{
    public class JobTypeSearchOutputModel
    {
        public Guid? JobTypeId { get; set; }
        public string JobTypeName { get; set; }
        public Guid? CompanyId { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public byte[] TimeStamp { get; set; }
        public int? TotalCount { get; set; }
    }
}
