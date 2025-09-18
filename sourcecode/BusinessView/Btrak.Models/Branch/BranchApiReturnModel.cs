using System;
using System.Text;

namespace Btrak.Models.Branch
{
    public class BranchApiReturnModel
    {
        public Guid? BranchId { get; set; }
        public string BranchName { get; set; }
        public DateTime CreatedDateTime { get; set; }
        public string CreatedOn { get; set; }
        public DateTime? InActiveDateTime { get; set; }
        public string InActiveOn { get; set; }
        public byte[] TimeStamp { get; set; }
        public int TotalCount { get; set; }
        public bool IsArchived { get; set; }
        public Guid? CompanyId { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public bool? IsHeadOffice { get; set; }
        public string Street { get; set; }
        public string City { get; set; }
        public string PostalCode { get; set; }
        public string State { get; set; }
        public string Address { get; set; }
        public Guid? TimeZoneId { get; set; }
        public string TimeZoneName { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("BranchId = " + BranchId);
            stringBuilder.Append(", BranchName = " + BranchName);
            stringBuilder.Append(", CreatedDateTime = " + CreatedDateTime);
            stringBuilder.Append(", CreatedOn = " + CreatedOn);
            stringBuilder.Append(", InActiveDateTime = " + InActiveDateTime);
            stringBuilder.Append(", InActiveOn = " + InActiveOn);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            stringBuilder.Append(", TotalCount = " + TotalCount);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", CompanyId = " + CompanyId);
            stringBuilder.Append(", CreatedByUserId= " + CreatedByUserId);
            stringBuilder.Append(",IsHeadOffice = " + IsHeadOffice);
            stringBuilder.Append(", Street = " + Street);
            stringBuilder.Append(", City = " + City);
            stringBuilder.Append(", PostalCode = " + PostalCode);
            stringBuilder.Append(", State = " + State);
            stringBuilder.Append(",Address = " + Address);
            return stringBuilder.ToString();
        }
    }
}
