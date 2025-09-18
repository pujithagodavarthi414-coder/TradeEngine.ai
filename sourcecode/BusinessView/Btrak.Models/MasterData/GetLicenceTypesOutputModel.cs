using System;
using System.Text;

namespace Btrak.Models.MasterData
{
    public class GetLicenceTypesOutputModel
    {
        public Guid? LicenceTypeId { get; set; }
        public string LicenceTypeName { get; set; }
        public DateTime? CreatedDate { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public byte[] TimeStamp { get; set; }
        public bool? IsArchived { get; set; }
        public int? TotalCount { get; set; }
       
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(" LicenceTypeId = " + LicenceTypeId);
            stringBuilder.Append(", LicenceTypeName = " + LicenceTypeName);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", CreatedDate = " + CreatedDate);
            stringBuilder.Append(", CreatedByUserId = " + CreatedByUserId);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            stringBuilder.Append(", TotalCount = " + TotalCount);
            return stringBuilder.ToString();
        }
    }
}
