using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PDFHTMLDesignerModels.CompanyStructure
{
    public class CompanyOutputModel
    {
        public Guid? CompanyId { get; set; }
        public string CompanyName { get; set; }
        public string SiteAddress { get; set; }
        public string WorkEmail { get; set; }
        public string Password { get; set; }
        public Guid? IndustryId { get; set; }
        public Guid? MainUseCaseId { get; set; }
        public string PhoneNumber { get; set; }
        public Guid? CountryId { get; set; }
        public Guid? TimeZoneId { get; set; }
        public Guid? CurrencyId { get; set; }
        public Guid? NumberFormatId { get; set; }
        public Guid? DateFormatId { get; set; }
        public Guid? TimeFormatId { get; set; }
        public long? TeamSize { get; set; } // converted to long because of an error converting 12454546546 in a test site
        public int? IsRemoteAccess { get; set; }
        public int? TrailDays { get; set; }
        public byte[] TimeStamp { get; set; }
        public int? VersionNumber { get; set; }
        public DateTime? InActiveDateTime { get; set; }
        public Guid? OriginalId { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public string LanCode { get; set; }
        public bool? IsDemoData { get; set; }
        public bool? IsSoftWare { get; set; }
        public string ReDirectionUrl { get; set; }
        public int? NoOfPurchasedLicences { get; set; }
        public string SiteDomain { get; set; }
        public string VAT { get; set; }
        public string PrimaryCompanyAddress { get; set; }
        public string RegistrerSiteAddress { get; set; }

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
            stringBuilder.Append(", TimeStamp  = " + TimeStamp);
            stringBuilder.Append(", TeamSize  = " + TeamSize);
            stringBuilder.Append(", VersionNumber  = " + VersionNumber);
            stringBuilder.Append(", InActiveDateTime  = " + InActiveDateTime);
            stringBuilder.Append(", OriginalId   = " + OriginalId);
            stringBuilder.Append(", CreatedDateTime  = " + CreatedDateTime);
            stringBuilder.Append(", CreatedByUserId  = " + CreatedByUserId);
            stringBuilder.Append(", IsDemoData = " + IsDemoData);
            return stringBuilder.ToString();
        }
    }
}
