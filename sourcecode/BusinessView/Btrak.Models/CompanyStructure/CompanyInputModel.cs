using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.CompanyStructure
{
    public class CompanyInputModel : InputModelBase
    {
        public CompanyInputModel() : base(InputTypeGuidConstants.CompanyInputCommandTypeGuid)
        {
        }
        public Guid? CompanyId { get; set; }
        public Guid? CompanyAuthenticationId { get; set; }
        public Guid? UserAuthenticationId { get; set; }
        public Guid? RoleId { get; set; }
        public string CompanyName { get; set; }
        public string SiteAddress { get; set; }
        public string WorkEmail { get; set; }
        public string BccEmail { get; set; }
        public string Password { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string MobileNumber { get; set; }
        public Guid? IndustryId { get; set; }
        public Guid? MainUseCaseId { get; set; }
        public string PhoneNumber { get; set; }
        public Guid? CountryId { get; set; }
        public Guid? TimeZoneId { get; set; }
        public Guid? CurrencyId { get; set; }
        public Guid? NumberFormatId { get; set; }
        public Guid? DateFormatId { get; set; }
        public Guid? TimeFormatId { get; set; }
        public long? TeamSize { get; set; }
        public bool? IsRemoteAccess { get; set; }
        public bool? IsArchived { get; set; }
        public bool IsDemoData { get; set; }
        public string MainPassword { get; set; }
        public string LangCode { get; set; }
        public bool? IsSoftWare { get; set; }
        public string ConfigurationUrl { get; set; }
        public string UserName { get; set; }
        public string EmailAddress { get; set; }
        public string RegistrerSiteAddress { get; set; }
        public int TrailPeriod { get; set; }

        public Guid? RegistorId { get; set; }
        public bool? IsVerify { get; set; }
        public string RegistrationTemplateName { get; set; }
        public int VerificationCode { get; set; }
        public int OTP { get; set; }
        public bool? IsResend { get; set; }
        public bool? IsOtpVerify { get; set; }
        public string ReDirectionUrl { get; set; }
        public string SiteDomain { get; set; }
        public string CompanyLogo { get; set; }
        public string CompanyRegistrationLogo { get; set; }
        public string CompanySigninLogo { get; set; }
        public string MailFooterAddress { get; set; }
        public string CompanyMiniLogo { get; set; }
        public string VAT { get; set; }
        public string Key { get; set; }
        public string PrimaryAddress { get; set; }
        public string RoleListXml { get; set; }
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", CompanyId   = " + CompanyId);
            stringBuilder.Append(", CompanyName  = " + CompanyName);
            stringBuilder.Append(", SiteAddress  = " + SiteAddress);    
            stringBuilder.Append(", WorkEmail   = " + WorkEmail);
            stringBuilder.Append(", Password  = " + Password);
            stringBuilder.Append(", IndustryId  = " + IndustryId);
            stringBuilder.Append(", MainUseCaseId   = " + MainUseCaseId);
            stringBuilder.Append(", PhoneNumber  = " + PhoneNumber);
            stringBuilder.Append(", CountryId  = " + CountryId);
            stringBuilder.Append(", TimeZoneId   = " + TimeZoneId);
            stringBuilder.Append(", CurrencyId  = " + CurrencyId);
            stringBuilder.Append(", NumberFormatId  = " + NumberFormatId);
            stringBuilder.Append(", DateFormatId   = " + DateFormatId);
            stringBuilder.Append(", TimeFormatId  = " + TimeFormatId);
            stringBuilder.Append(", IsArchived  = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}
