using System;

namespace Btrak.Dapper.Dal.SpModels
{
    public class SupplierSpEntity
    {
        public Guid Id { get; set; }
        public Guid CompanyId { get; set; }
        public string SupplierName { get; set; }
        public string CompanyName { get; set; }
        public string ContactPerson { get; set; }
        public string ContactPosition { get; set; }
        public string CompanyPhoneNumber { get; set; }
        public string ContactPhoneNumber { get; set; }
        public string VendorIntroducedBy { get; set; }
        public DateTime StartedWorkingFrom { get; set; }
        public DateTime CreatedDateTime { get; set; }
        public Guid CreatedByUserId { get; set; }
        public DateTime UpdatedDateTime { get; set; }
        public Guid UpdatedByUserId { get; set; }
    }
}
