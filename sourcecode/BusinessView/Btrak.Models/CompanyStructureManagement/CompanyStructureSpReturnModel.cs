using System;

namespace Btrak.Models.CompanyStructureManagement
{
    public class CompanyStructureSpReturnModel
    {
        public Guid? CountryId { get; set; }
        public string CountryName { get; set; }
        public string RegionsXml { get; set; }
        public int TotalCount { get; set; }
    }
}
