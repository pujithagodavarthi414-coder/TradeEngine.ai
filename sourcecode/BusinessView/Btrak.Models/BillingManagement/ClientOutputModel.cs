using System;
using System.Collections.Generic;
using System.Text;

namespace Btrak.Models.BillingManagement
{
    public class ClientOutputModel
    {
        public Guid? ClientId { get; set; }
        public Guid? BuyerId { get; set; }
        public Guid? ClientAddressId { get; set; }
        public Guid? UserId { get; set; }
        public Guid? UserAuthenticationId { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string FullName { get; set; }
        public string AvatarName { get; set; }
        public string Email { get; set; }
        public string ProfileImage { get; set; }
        public string MobileNo { get; set; }
        public string Password { get; set; }
        public Guid? CompanyId { get; set; }
        public string CompanyName { get; set; }
        public string CompanyWebsite { get; set; }
        public Guid? CountryId { get; set; }
        public string Zipcode { get; set; }
        public string Street { get; set; }
        public string City { get; set; }
        public string State { get; set; }
        public string CountryName { get; set; }
        public string CountryCode { get; set; }
        public string ClientTypeName { get; set; }
        public string ClientKycName { get; set; }
        public Guid? ClientType { get; set; }
        public Guid? KycDocument { get; set; }
        public string Note { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public string KycFormData { get; set; }
        public string ProjectName { get; set; }
        public int VersionNumber { get; set; }
        public bool IsArchived { get; set; }
        public bool IsActive { get; set; }
        public byte[] TimeStamp { get; set; }
        public byte[] ClientAddressTimeStamp { get; set; }
        public int TotalCount { get; set; }
        public List<Guid> RoleId { get; set; }
        public string RoleIds { get; set; }
        public List<Guid> ContractTemplateId { get; set; }
        public string ContractTemplateIds { get; set; }
        public List<Guid> TradeTemplateId { get; set; }
        public string TradeTemplateIds { get; set; }
        public string FormJson { get; set; }
        public bool IsClientKyc { get; set; }
        public bool kycCompleted { get; set; }
      
        public Guid? LeadFormId { get; set; }
        public string LeadFormData { get; set; }

        public Guid? ContractFormId { get; set; }
        public string ContractFormData { get; set; }
        public string ContractFormJson { get; set; }
        public decimal CreditLimit { get; set; }
        public decimal AvailableCreditLimit { get; set; }
        public string LeadSubmissions { get; set; }
        public string ContractSubmissions { get; set; }
        public string AddressLine1 { get; set; }
        public string AddressLine2 { get; set; }
        public string PanNumber { get; set; }
        public string BusinessEmail { get; set; }
        public string BusinessNumber { get; set; }
        public string EximCode { get; set; }
        public string GstNumber { get; set; }
        public Guid? TimeZoneId { get; set; }
        public string TimeZoneName { get; set; }
        public List<LeadSubmissionsDetails> LeadSubmissionsDetails { get; set; }

        public List<ContractSubmissionDetails> ContractSubmissionsDetails { get; set; }
        public string ShipToAddress { get; set; }
        public int KycExpiryDays { get; set; }
        public Guid? LegalEntityId { get; set; }
        public bool IsKycSybmissionMailSent { get; set; }
        public bool IsFirstKYC { get; set; }
        public DateTime? KycExpireDate { get; set; }
        public DateTime? KycRemindDate { get; set; }
        public Guid? KycFormStatusId { get; set; }
        public string KycStatusName { get; set; }
        public string StatusName { get; set; }
        public string StatusColor { get; set; }
        public string BusinesCountryCode { get; set; }
        public string PhoneCountryCode { get; set; }
        public double? BrokerageValue { get; set; }
        public string IECCode { get; set; }
        public string FormBgColor { get; set; }
        public string RoleNames { get; set; }
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("ClientId" + ClientId);
            stringBuilder.Append("ClientAddressId" + ClientAddressId);
            stringBuilder.Append("UserId" + UserId);
            stringBuilder.Append("FirstName" + FirstName);
            stringBuilder.Append("LastName" + LastName);
            stringBuilder.Append("FullName" + FullName);
            stringBuilder.Append("AvatarName" + AvatarName);
            stringBuilder.Append("Email" + Email);
            stringBuilder.Append("ProfileImage" + ProfileImage);
            stringBuilder.Append("MobileNo" + MobileNo);
            stringBuilder.Append("Password" + Password);
            stringBuilder.Append("CompanyId" + CompanyId);
            stringBuilder.Append("CompanyName" + CompanyName);
            stringBuilder.Append("CompanyWebsite" + CompanyWebsite);
            stringBuilder.Append("CountryId" + CountryId);
            stringBuilder.Append("Zipcode" + Zipcode);
            stringBuilder.Append("Street" + Street);
            stringBuilder.Append("City" + City);
            stringBuilder.Append("State" + State);
            stringBuilder.Append("CountryName" + CountryName);
            stringBuilder.Append("Note" + Note);
            stringBuilder.Append("ProjectName" + ProjectName);
            stringBuilder.Append("VersionNumber" + VersionNumber);
            stringBuilder.Append("IsArchived" + IsArchived);
            stringBuilder.Append("TimeStamp" + TimeStamp);
            stringBuilder.Append("ClientAddressTimeStamp" + ClientAddressTimeStamp);
            stringBuilder.Append("TotalCount" + TotalCount);
            stringBuilder.Append("TimeZoneId" + TimeZoneId);
            stringBuilder.Append("TimeZoneName" + TimeZoneName);
            return base.ToString();
        }

    }
}
