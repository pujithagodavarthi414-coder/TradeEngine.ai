using System;

namespace Btrak.Models.PayRoll
{
    public class EmployeeAccountDetailsSearchOutputModel
    {
        public Guid? EmployeeAccountDetailsId { get; set; }
        public string PFNumber { get; set; }
        public string UANNumber { get; set; }
        public string ESINumber { get; set; }
        public string PANNumber { get; set; }
        public bool? IsArchived { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public DateTime? InActiveDateTime { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public byte[] TimeStamp { get; set; }
        public int? TotalCount { get; set; }
    }
}
