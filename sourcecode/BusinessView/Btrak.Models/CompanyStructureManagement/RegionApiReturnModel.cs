using System;
using System.Text;
using System.Xml.Serialization;
using Btrak.Models.Branch;

namespace Btrak.Models.CompanyStructureManagement
{
    public class RegionApiReturnModel
    {
        public Guid? RegionId { get; set; }
        public string RegionName { get; set; }
        public Guid? CountryId { get; set; }
        public string CountryName { get; set; }
        public DateTime CreatedDateTime { get; set; }
        public string CreatedOn { get; set; }
        public DateTime? InActiveDateTime { get; set; }
        public string InActiveOn { get; set; }
        public byte[] TimeStamp { get; set; }
        public int TotalCount { get; set; }

        public BranchesXml BranchesXml { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("RegionId = " + RegionId);
            stringBuilder.Append(", RegionName = " + RegionName);
            stringBuilder.Append(", CountryId = " + CountryId);
            stringBuilder.Append(", CountryName = " + CountryName);
            stringBuilder.Append(", CreatedDateTime = " + CreatedDateTime);
            stringBuilder.Append(", CreatedOn = " + CreatedOn);
            stringBuilder.Append(", InActiveDateTime = " + InActiveDateTime);
            stringBuilder.Append(", InActiveOn = " + InActiveOn);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            stringBuilder.Append(", TotalCount = " + TotalCount);
            return stringBuilder.ToString();
        }
    }

    [XmlRoot(ElementName = "BranchesXml")]
    public class BranchesXml
    {
        [XmlElement(ElementName = "BranchApiReturnModel")]
        public BranchApiReturnModel BranchApiReturnModel { get; set; }
    }
}
