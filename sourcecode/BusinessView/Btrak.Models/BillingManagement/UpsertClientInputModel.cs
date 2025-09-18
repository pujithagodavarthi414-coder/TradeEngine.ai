using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Text;

namespace Btrak.Models.BillingManagement
{
    public class UpsertClientInputModel : InputModelBase
    {

        public UpsertClientInputModel() : base(InputTypeGuidConstants.UpsertClientInputCommandTypeGuid)
        {
        }
        public Guid? UserAuthenticationId { get; set; }
        public Guid? ClientId { get; set; }
        public Guid? ClientAddressId { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string Email { get; set; }
        public string Note { get; set; }
        public string Password { get; set; }
        public string MobileNo { get; set; }
        public string ProfileImage { get; set; }
        public string CompanyName { get; set; }
        public string CompanyWebsite { get; set; }
        public Guid? CountryId { get; set; }
        public string CountryName { get; set; }
        public string CountryCode { get; set; }
        public string Street { get; set; }
        public string City { get; set; }
        public string State { get; set; }
        public string Zipcode { get; set; }
        public bool IsArchived { get; set; }
        public bool IsActive { get; set; }
        public byte[] TimeStamp { get; set; }
        public double? BrokerageValue { get; set; }
        public byte[] ClientAddressTimeStamp { get; set; }
        public int TotalCount { get; set; }
        public List<Guid> RoleId { get; set; }
        public string RoleIds { get; set; }        
        public List<Guid> ContractTemplateId { get; set; }
        public string ContractTemplateIds { get; set; }
        public List<Guid> TradeTemplateId { get; set; }
        public string TradeTemplateIds { get; set; }
        public Guid? ClientType { get; set; }
        public Guid? KycDocument { get; set; }
        public Guid? LeadFormId { get; set; }
        public string LeadFormData { get; set; }
        public string LeadFormJson { get; set; }
        public Guid? ContractFormId { get; set; }
        public string ContractFormData { get; set; }
        public string ContractFormJson { get; set; }
        public decimal CreditLimit { get; set; }
        public decimal AvailableCreditLimit { get; set; }
        public List<Component> Components { get; set; }
        public bool IsForLeadSubmission { get; set; }
        public Guid? LeadSubmissionId { get; set; }
        public Guid? TimeZoneId { get; set; }
        public decimal CreditsAllocated { get; set; }
        public string AddressLine1 { get; set; }
        public string AddressLine2 { get; set; }
        public string PanNumber { get; set; }
        public string BusinessEmail { get; set; }
        public string BusinessNumber { get; set; }
        public string EximCode { get; set; }
        public string GstNumber { get; set; }
        public string BusinesCode { get; set; }
        public string PhoneCountryCode { get; set; }
        public int KycExpiryDays { get; set; }
        public Guid? LegalEntityId { get; set; }
        public bool IsKycSybmissionMailSent { get; set; }
        public bool IsVerified { get; set; }
        public bool? IsSavingContractTemplates { get; set; }
        public bool? IsSavingTradeTemplates { get; set; }


        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("ClientId" + ClientId);
            stringBuilder.Append("ClientAddressId" + ClientAddressId);
            stringBuilder.Append("FirstName" + FirstName);
            stringBuilder.Append("LastName" + LastName);
            stringBuilder.Append("Email" + Email);
            stringBuilder.Append("Note" + Note);
            stringBuilder.Append("Password" + Password);
            stringBuilder.Append("MobileNo" + MobileNo);
            stringBuilder.Append("ProfileImage" + ProfileImage);
            stringBuilder.Append("CompanyName" + CompanyName);
            stringBuilder.Append("CompanyWebsite" + CompanyWebsite);
            stringBuilder.Append("CountryId" + CountryId);
            stringBuilder.Append("CountryName" + CountryName);
            stringBuilder.Append("Street" + Street);
            stringBuilder.Append("City" + City);
            stringBuilder.Append("State" + State);
            stringBuilder.Append("IsArchived" + IsArchived);
            stringBuilder.Append("TimeStamp" + TimeStamp);
            stringBuilder.Append("TimeZoneId" + TimeZoneId);
            stringBuilder.Append("ClientAddressTimeStamp" + ClientAddressTimeStamp);
            stringBuilder.Append("TotalCount" + TotalCount);
            stringBuilder.Append("LeadFormId" + LeadFormId);
            stringBuilder.Append("LeadFormData" + LeadFormData);
            stringBuilder.Append("IsForLeadSubmission" + IsForLeadSubmission);
            return base.ToString();
        }

        public class Component
        {
            public string Label { get; set; }
            public string Key { get; set; }
        }
    }
}