using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.Branch
{
    public class BranchUpsertInputModel : InputModelBase
    {
        public BranchUpsertInputModel() : base(InputTypeGuidConstants.BranchUpsertInputCommandTypeGuid)
        {
        }

        public Guid? BranchId { get; set; }
        public string BranchName { get; set; }
        public bool IsArchived { get; set; }
        public bool? IsHeadOffice { get; set; }
        public string Street { get; set; }
        public string City { get; set; }
        public string PostalCode { get; set; }
        public string State { get; set; }
        public string AddressJSON { get; set; }
        public Guid? TimeZoneId { get; set; }
         
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("BranchId = " + BranchId);
            stringBuilder.Append(", BranchName = " + BranchName);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", IsHeadOffice = " + IsHeadOffice);
            stringBuilder.Append(", Street = " + Street);
            stringBuilder.Append(", City = " + City);
            stringBuilder.Append(", PostalCode = " + PostalCode);
            stringBuilder.Append(", State = " + State);
            stringBuilder.Append(", TimeZoneId = " + TimeZoneId);
            return stringBuilder.ToString();
        }
    }

    public class Address
    {
        public string Street { get; set; }
        public string City { get; set; }
        public string PostalCode { get; set; }
        public string State { get; set; }

    }
}