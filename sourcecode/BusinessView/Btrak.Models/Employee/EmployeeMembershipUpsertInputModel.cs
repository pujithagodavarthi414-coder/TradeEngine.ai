using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.Employee
{
    public class EmployeeMembershipUpsertInputModel : InputModelBase
    {
        public EmployeeMembershipUpsertInputModel() : base(InputTypeGuidConstants.EmployeeMembershipUpsertInputCommandTypeGuid)
        {
        }

        public Guid? EmployeeMembershipId { get; set; }
        public Guid? EmployeeId { get; set; }
        public Guid? MembershipId { get; set; }
        public Guid? SubscriptionId { get; set; }
        public decimal? SubscriptionAmount { get; set; }
        public Guid? CurrencyId { get; set; }
        public DateTime? CommenceDate { get; set; }
        public DateTime? RenewalDate { get; set; }
        public bool IsArchived { get; set; }
        public string NameOfTheCertificate { get; set; }
        public string IssueCertifyingAuthority { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("EmployeeMembershipId = " + EmployeeMembershipId);
            stringBuilder.Append(", EmployeeId = " + EmployeeId);
            stringBuilder.Append(", MembershipId = " + MembershipId);
            stringBuilder.Append(", SubscriptionId = " + SubscriptionId);
            stringBuilder.Append(", SubscriptionAmount = " + SubscriptionAmount);
            stringBuilder.Append(", CurrencyId = " + CurrencyId);
            stringBuilder.Append(", CommenceDate = " + CommenceDate);
            stringBuilder.Append(", RenewalDate = " + RenewalDate);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", nameOfTheCertificate = " + NameOfTheCertificate);
            stringBuilder.Append(", issueCertifyingAuthority = " + IssueCertifyingAuthority);
            return stringBuilder.ToString();
        }
    }
}