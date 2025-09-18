using System;

namespace Btrak.Models.CompanyStructureManagement
{
    public class RegionSpReturnModel
    {
        public Guid? RegionId { get; set; }
        public string RegionName { get; set; }
        public Guid? CountryId { get; set; }
        public string CountryName { get; set; }
        public DateTime CreatedDateTime { get; set; }
        public DateTime? InActiveDateTime { get; set; }
        public byte[] TimeStamp { get; set; }
        public int TotalCount { get; set; }
    }
}
