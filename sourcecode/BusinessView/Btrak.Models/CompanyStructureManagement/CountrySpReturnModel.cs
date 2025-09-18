using System;

namespace Btrak.Models.CompanyStructureManagement
{
    public class CountrySpReturnModel
    {
        public Guid? CountryId { get; set; }
        public string CountryName { get; set; }
        public string CountryCode { get; set; }
        public DateTime CreatedDateTime { get; set; }
        public DateTime? InActiveDateTime { get; set; }
        public bool IsArchived { get; set; }
        public byte[] TimeStamp { get; set; }
        public int TotalCount { get; set; }
    }
}
