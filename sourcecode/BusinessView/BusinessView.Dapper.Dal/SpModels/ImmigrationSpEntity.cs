using System;

namespace Btrak.Dapper.Dal.SpModels
{
    public class ImmigrationSpEntity
    {
        public Guid Id { get; set; }
        public Guid EmployeeId { get; set; }
        public string Document { get; set; }
        public string DocumentNumber { get; set; }
        public DateTime IssuedDate { get; set; }
        public DateTime ExpiryDate { get; set; }
        public decimal? Cost { get; set; }
        public string EligibleStatus { get; set; }
        public Guid CountryId { get; set; }
        public DateTime EligibleReviewDate { get; set; }
        public string Comments { get; set; }
        public bool IsVendor { get; set; }
        public bool IsEmpty { get; set; }
        public bool IsWriteOff { get; set; }
        public Guid AssignedToEmployee { get; set; }
        public DateTime ActiveFrom { get; set; }
        public DateTime ActiveTo { get; set; }
        public DateTime CreatedDateTime { get; set; }
        public Guid CreatedByUserId { get; set; }
        public string MasterValue { get; set; }
    }
}
