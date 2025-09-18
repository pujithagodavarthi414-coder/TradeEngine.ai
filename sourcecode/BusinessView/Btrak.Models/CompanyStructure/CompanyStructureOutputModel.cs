using System;
using System.Text;

namespace Btrak.Models.CompanyStructure
{
    public class CompanyStructureOutputModel
    {
        public Guid? IndustryId { get; set; }
        public string IndustryName { get; set; }
        public string TotalCount { get; set; }
        public bool IsArchived { get; set; }
        public byte[] TimeStamp { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", IndustryId  = " + IndustryId);
            stringBuilder.Append(", IndustryName  = " + IndustryName);
            stringBuilder.Append(", TotalCount  = " + TotalCount);
            stringBuilder.Append(", IsArchived  = " + IsArchived);
            stringBuilder.Append(", TimeStamp  = " + TimeStamp);
            return stringBuilder.ToString();
        }
    }
}
