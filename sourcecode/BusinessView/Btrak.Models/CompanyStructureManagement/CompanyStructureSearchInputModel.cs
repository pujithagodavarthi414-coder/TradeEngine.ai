using System;

namespace Btrak.Models.CompanyStructureManagement
{
    public class CompanyStructureSearchInputModel
    {
        public Guid? CountryId { get; set; }
        public Guid? RegionId { get; set; }
        public Guid? BranchId { get; set; }
        public string CountryNameSearchText { get; set; }
        public string RegionNameSearchText { get; set; }
        public string BranchNameSearchText { get; set; }
    }
}
