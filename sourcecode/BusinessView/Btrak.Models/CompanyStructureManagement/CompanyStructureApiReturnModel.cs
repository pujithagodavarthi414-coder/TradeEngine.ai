using System;
using System.Collections.Generic;
using System.Text;

namespace Btrak.Models.CompanyStructureManagement
{
    public class CompanyStructureApiReturnModel
    {
        public CompanyStructureApiReturnModel()
        {
            Regions = new List<RegionApiReturnModel>();
        }

        public Guid? CountryId { get; set; }
        public string CountryName { get; set; }
        public int TotalCount { get; set; }

        public List<RegionApiReturnModel> Regions { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("CountryId = " + CountryId);
            stringBuilder.Append(", CountryName = " + CountryName);
            stringBuilder.Append(", TotalCount = " + TotalCount);
            return stringBuilder.ToString();
        }
    }
}
