using System;
using System.Text;

namespace Btrak.Models.Employee
{
    public class EmployeeMembershipDetailsApiReturnModel
    {
        public Guid? EmployeeId { get; set; }
        public Guid? EmployeeMembershipId { get; set; }
        public string FirstName { get; set; }
        public string SurName { get; set; }
        public string UserName { get; set; }
        public string Email { get; set; }
        public Guid? MembershipId { get; set; }
        public string Membership { get; set; }
        public Guid? SubscriptionId { get; set; }
        public string SubscriptionPaidByName { get; set; }
        public decimal? SubscriptionAmount { get; set; }
        public Guid? CurrencyId { get; set; }
        public string CurrencyName { get; set; }
        public DateTime? CommenceDate { get; set; }
        public DateTime? RenewalDate { get; set; }
        public byte[] TimeStamp { get; set; }
        public int TotalCount { get; set; }
        public bool IsArchived { get; set; }
        public Guid? UserId { get; set; }
        public string NameOfTheCertificate { get; set; }
        public string IssueCertifyingAuthority { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("EmployeeId = " + EmployeeId);
            stringBuilder.Append(", EmployeeMembershipId = " + EmployeeMembershipId);
            stringBuilder.Append(", FirstName = " + FirstName);
            stringBuilder.Append(", SurName = " + SurName);
            stringBuilder.Append(", UserName = " + UserName);
            stringBuilder.Append(", Email = " + Email);
            stringBuilder.Append(", MembershipId = " + MembershipId);
            stringBuilder.Append(", NameOfTheCertificate = " + NameOfTheCertificate);
            stringBuilder.Append(", IssueCertifyingAuthority = " + IssueCertifyingAuthority);
            stringBuilder.Append(", Membership = " + Membership);
            stringBuilder.Append(", SubscriptionId = " + SubscriptionId);
            stringBuilder.Append(", SubscriptionPaidByName = " + SubscriptionPaidByName);
            stringBuilder.Append(", SubscriptionAmount = " + SubscriptionAmount);
            stringBuilder.Append(", CurrencyId = " + CurrencyId);
            stringBuilder.Append(", CurrencyName = " + CurrencyName);
            stringBuilder.Append(", CommenceDate = " + CommenceDate);
            stringBuilder.Append(", RenewalDate = " + RenewalDate);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            stringBuilder.Append(", TotalCount = " + TotalCount);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", UserId = " + UserId);
            return stringBuilder.ToString();
        }
    }
}
